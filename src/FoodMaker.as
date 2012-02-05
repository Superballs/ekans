package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;

	public class FoodMaker extends Entity
	{	
		private const FOOD_SPAWN_TIME_INTERVAL : Number = 6;
		private var _elapsedTimeSinceLastFood: Number;

		public function FoodMaker() 
		{
			active = true;
			
			_elapsedTimeSinceLastFood = FOOD_SPAWN_TIME_INTERVAL;
		}

		override public function update():void 
		{
			_elapsedTimeSinceLastFood += FP.elapsed;

			//TODO have a max-foods thing?
			if (_elapsedTimeSinceLastFood > FOOD_SPAWN_TIME_INTERVAL)
			{
				_elapsedTimeSinceLastFood -= FOOD_SPAWN_TIME_INTERVAL;
				makeFood();
			}
		}

		override public function removed() : void
		{			
			for each ( var food : Food in Arena.foods )
			{
				world.remove(food);
			}		
		}
				
		public function makeFood() : void
		{
			const MAX_ATTEMPTS: int = 50;		
			var attempts: int = 0;
			var tempX : int;
			var tempY : int;
						
			do {
				attempts++;
				tempX = (Math.random()* (Arena.GRID_WIDTH - 1));
				tempY = (Math.random() * (Arena.GRID_HEIGHT - 1));
				
				var isValidHeroX : Boolean = Math.abs(tempX - Arena.getHero()._gridX) > 1;
				var isValidHeroY : Boolean = Math.abs(tempY - Arena.getHero()._gridY) > 1;
				var isValidSnakeX : Boolean = Math.abs(tempX - Arena.getSnake().getBody()[0]._gridX) > 1;
				var isValidSnakeY : Boolean = Math.abs(tempY - Arena.getSnake().getBody()[0]._gridY) > 1;						
				var isEmptyTile : Boolean = Arena.grid[tempX][tempY] == TileType.EMPTY;
				var isValidAttempts : Boolean = attempts < MAX_ATTEMPTS;
				var isValidLocation : Boolean = isValidHeroX && isValidHeroY && isValidSnakeX && isValidSnakeY && isEmptyTile && isValidAttempts;
			} while ( !isValidLocation && isValidAttempts );

			if (isValidLocation)
			{
				var newFood : Food = new Food(tempX, tempY);
				Arena.foods.push(newFood);
				world.add(newFood);
				Arena.getPharoah().playAnimation();
			}
		}
	}

}