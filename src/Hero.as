package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class Hero extends Entity
	{
		[ Embed( source = 'assets/EKANS SOUNDS/hero death scream.mp3' ) ] private const DEATH:Class;
		
		[ Embed( source = 'assets/idle.png' ) ] private const PLAYER_IDLE : Class;
		[ Embed( source = 'assets/run_back.png' ) ] private const PLAYER_UP : Class;
		[ Embed( source = 'assets/run_front.png' ) ] private const PLAYER_DOWN : Class;
		[ Embed( source = 'assets/run_left.png' ) ] private const PLAYER_LEFT : Class;
		[ Embed( source = 'assets/run_right.png' ) ] private const PLAYER_RIGHT : Class;
		[ Embed( source = 'assets/player.png' ) ] private const PLAYER : Class;

		static private var _moveInput : int;
		static private const IDLE : int = 0;
		
		public var _gridX : int;
		public var _gridY : int;		
		
		public var idleSpriteMap : Spritemap = new Spritemap(PLAYER_IDLE, 60, 60);
		public var upSpriteMap : Spritemap = new Spritemap(PLAYER_UP, 60, 60);
		public var downSpriteMap : Spritemap  = new Spritemap(PLAYER_DOWN, 60, 60);
		public var leftSpriteMap : Spritemap  = new Spritemap(PLAYER_LEFT, 60, 60);
		public var rightSpriteMap : Spritemap  = new Spritemap(PLAYER_RIGHT, 60, 60);
		
		private const timeBetweenMoving : Number = 0.3;
		private var elapsedTimeSinceLastMove : Number;
		
		private const SPEED : Number = 2.0;//1.6;//(Arena.GRID_SIZE * timeBetweenMoving) / 10;
		
		private var moving : Boolean;
		
		//private const 
		//private var destinationTile : Tile;
		
		public function Hero(gridX : int, gridY : int) 
		{
			active = true;
			
			//graphic = new Image( PLAYER );
			_gridX = gridX;
			_gridY = gridY;
			
			Arena.grid[ _gridX ][ _gridY ] = TileType.HERO;
			
			_moveInput = 0;
			
			var idleArray : Array = new Array();
			for (var i : int = 0; i < 60; i++) {
				idleArray.push(i);
			}
			
			moving = false;
			
			var adjustArray : Array = new Array();
			for (i = 60; i < 120; i++) {
				adjustArray.push(i);
			}
			
			//FrameRate != framerate
			//frameRate is the number of entire animation sequences per second
			idleSpriteMap.add("idle", idleArray, 0.8, true);
			idleSpriteMap.add("adjust", adjustArray, 0.8, true);
			upSpriteMap.add("up", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 5, 16, 17, 18, 19, 20], 1, true);
			downSpriteMap.add("down", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 5, 16, 17, 18, 19, 20], 1, true);
			leftSpriteMap.add("left", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 5, 16, 17, 18, 19], 0.5, true);
			rightSpriteMap.add("right", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 5, 16, 17, 18, 19], 0.5, true);
			
			idleSpriteMap.play("idle", true);
			graphic = idleSpriteMap;
			graphic.x = -14;
			graphic.y = -14;
			
			x = Arena.gridToPixelsX(_gridX);
			y = Arena.gridToPixelsY(_gridY);
			elapsedTimeSinceLastMove = 0;
		}
		
		override public function update() : void
		{
			//elapsedTimeSinceLastMove += FP.elapsed;
			getMoveInput();
			
			if (!moving && _moveInput != IDLE) {
				moving = true;
				applyMove();
				elapsedTimeSinceLastMove = 0;
				updateSprite();
			} else {
				elapsedTimeSinceLastMove += FP.elapsed;
				if (elapsedTimeSinceLastMove > timeBetweenMoving) {
					elapsedTimeSinceLastMove -= timeBetweenMoving;
					moving = false;
					updateSprite();
				}
			}
			
			/*
			if (elapsedTimeSinceLastMove > timeBetweenMoving)
			{
				elapsedTimeSinceLastMove -= timeBetweenMoving;
				
			}*/
			moveLerp();
		}
				
		private function getMoveInput() : void
		{
			if ( Input.check( Key.LEFT ) ) _moveInput = Key.LEFT;
			else if ( Input.check( Key.RIGHT ) ) _moveInput = Key.RIGHT;
			else if ( Input.check( Key.UP ) ) _moveInput = Key.UP;
			else if ( Input.check( Key.DOWN ) ) _moveInput = Key.DOWN;
			else if (Input.released( Key.LEFT ) || Input.released( Key.RIGHT )
			|| Input.released( Key.UP ) || Input.released( Key.DOWN )) {
				_moveInput = 0;
			}
		}
		
		private function updateSprite():void {
			switch ( _moveInput )
			{
				case Key.UP:
					if (graphic != upSpriteMap) {
						upSpriteMap.play("up", true);
						graphic = upSpriteMap;
					}
					break;

				case Key.DOWN:
					if (graphic != downSpriteMap) {
						downSpriteMap.play("down", true);
						graphic = downSpriteMap;
					}
					break;

				case Key.LEFT:
					if (graphic != leftSpriteMap) {
						leftSpriteMap.play("left", true);
						graphic = leftSpriteMap;
					}
					break;
				
				case Key.RIGHT:
					if (graphic != rightSpriteMap) {
						rightSpriteMap.play("right", true);
						graphic = rightSpriteMap;
					}
					break;
			
				default:
					if (graphic != idleSpriteMap) {
						idleSpriteMap.play("idle", true);
						graphic = idleSpriteMap;
					}
					//throw new Error( "Illegal direction argument: " + _moveInput );
					break;
			}
			graphic.x = -14;
			graphic.y = -14;
		}
		
		//TODO: Step towards
		private function moveLerp() : void
		{
			FP.stepTowards(this, Arena.gridToPixelsX(_gridX), Arena.gridToPixelsY(_gridY), SPEED);
		}
		
		private function applyMove() : void
		{
			
			//align to grid
			x = Arena.gridToPixelsX(_gridX);
			y = Arena.gridToPixelsY(_gridY);
			
			var destinationTile : Tile = getDestinationTile();

			//trace( "dt: " + Arena.grid[ destinationTile._gridX ][ destinationTile._gridY ] );
			if (Arena.grid[ destinationTile._gridX ][ destinationTile._gridY ] != TileType.EMPTY  &&
				Arena.grid[ destinationTile._gridX ][ destinationTile._gridY ] != TileType.FOOD )
			{
				return;
			}
			
			if (Arena.getTileType( destinationTile ) == TileType.FOOD)
			{
				touchFood( destinationTile );
			}
			
			if (Arena.getTileType( destinationTile ) == TileType.FOOD ||
				Arena.getTileType( destinationTile ) == TileType.EMPTY)
			{
				//clear the old grid space
				Arena.grid[ _gridX ][ _gridY ] = TileType.EMPTY;
					
				_gridX = destinationTile._gridX;
				_gridY = destinationTile._gridY;
			
				Arena.grid[ _gridX ][ _gridY ] = TileType.HERO;
			}
			
			
			switch ( Arena.getTileType( destinationTile ) )
			{
				/*
				case Arena.FOOD:
					touchFood( destinationTile );	
					break;*/

				case TileType.SNAKE:
					touchSnake( destinationTile );	
					break;
			}
		}
		
		private function getDestinationTile() : Tile 
		{
			var tile : Tile;
			var gridX : int = _gridX;
			var gridY : int = _gridY;
			
			switch ( _moveInput )
			{
				case Key.UP:
					gridY--;
					break;

				case Key.DOWN:
					gridY++;
					break;

				case Key.LEFT:
					gridX--;
					break;
				
				case Key.RIGHT:
					gridX++;
					break;
			
				case 0:
					break;
					
				default:
					throw new Error( "Illegal direction argument: " + _moveInput );
					break;
			}
			
			if (gridX < 0 || gridX >= Arena.GRID_WIDTH ||
				gridY < 0 || gridY >= Arena.GRID_HEIGHT) return new Tile(_gridX, _gridY);
			
			return new Tile( gridX, gridY );
		}
		
		override public function removed () : void {
			var death:Sfx = new Sfx(DEATH);
			death.play();
		}
		
		private function touchFood( foodTile : Tile ) : void
		{
			//TODO refactor out into Arena
			for ( var i: int = 0; i != Arena.foods.length; i++ )
			{
				if ( Arena.foods[ i ]._gridX == foodTile._gridX &&
					Arena.foods[ i ]._gridY == foodTile._gridY )
				{
					//destroy the food 
					var toDelete: Food  = Arena.foods[ i ];				
					world.remove( toDelete );
					Arena.foods.splice( i, 1 );
					
					if (world) world.add(new SpEffect(Arena.gridToPixelsX(foodTile._gridX) -34,
						Arena.gridToPixelsY(foodTile._gridY) - 210, "aura"));
					break;
				}
			}
			Score.addRescueToScore();
			Arena.getSnake().modifySpeed( false );
			Arena.getSnake().playModifySpeedSound();
		}

		private function touchSnake( tile : Tile ) : void
		{
		}
	}
}