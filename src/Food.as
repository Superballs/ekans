package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;

	public class Food extends Entity
	{
		[ Embed( source = 'assets/cowards.png') ] private const FOOD : Class;
		[ Embed( source = 'assets/falling cowards.png') ] private const FALLING_FOOD : Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward lands 01.mp3' ) ] private const FALL1:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward lands 02.mp3' ) ] private const FALL2:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward lands 03.mp3' ) ] private const FALL3:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward cry 01.mp3' ) ] private const SCREAM1:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward cry 02.mp3' ) ] private const SCREAM2:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/coward cry 03.mp3' ) ] private const SCREAM3:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/pleb death 01.mp3' ) ] private const DEATH1:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/pleb death 02.mp3' ) ] private const DEATH2:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/pleb death 03.mp3' ) ] private const DEATH3:Class;
		[ Embed( source = 'assets/EKANS SOUNDS/pleb death 04.mp3' ) ] private const DEATH4:Class;
		
		
		public var _gridX: int;
		public var _gridY: int;
		private var spriteMap : Spritemap;
		private var personNo : int;
		private var falling : Boolean;
		private var destX : int;
		private var destY : int;
		
		
		public function pickPeasant():void { 
			if (!falling) {
				spriteMap = new Spritemap(FOOD, 60, 60);
				switch (personNo) {
					case 0:
						spriteMap.add("person1R", [53, 0, 1, 2, 3], 0.3, true);
						spriteMap.play("person1R",true);
						break;
					case 1:
						spriteMap.add("person1L", [4, 5, 6, 7, 8], 0.3, true);
						spriteMap.play("person1L", true);
						break;
					case 2:
						spriteMap.add("person2R", [9, 10, 11, 12, 13], 0.3, true);
						spriteMap.play("person2R", true);
						break;
					case 3:
						spriteMap.add("person2L", [14, 15, 16, 17, 18], 0.3, true);
						spriteMap.play("person2L", true);
						break;
					case 4:
						spriteMap.add("person3R", [19, 20, 21, 22, 23], 0.3, true);
						spriteMap.play("person3R", true);
						break;
					case 5:
						spriteMap.add("person3L", [24, 25, 26, 27, 28], 0.3, true);
						spriteMap.play("person3L", true);
						break;
					case 6:
						spriteMap.add("person4R", [29, 30, 31, 32], 0.3, true);
						spriteMap.play("person4R", true);
						break;
					case 7:
						spriteMap.add("person4L", [33, 34, 35, 36], 0.3, true);
						spriteMap.play("person4L", true);
						break;
					case 8:
						spriteMap.add("person5R", [37, 38, 39, 40], 0.3, true);
						spriteMap.play("person5R", true);
						break;
					case 9:
						spriteMap.add("person5L", [41, 42, 43, 44], 0.3, true);
						spriteMap.play("person5L", true);
						break;
					case 10:
						spriteMap.add("person6R", [45, 46, 47, 48 ], 0.3, true);
						spriteMap.play("person6R", true);
						break;
					case 11:
						spriteMap.add("person6L", [49, 50, 51, 52 ], 0.3, true);
						spriteMap.play("person6L", true);
						break;
					default:
						spriteMap.add("person1R", [53, 0, 1, 2, 3], 0.3, true);
						spriteMap.play("person1R", true);
						break;
				}
			} else {
				spriteMap = new Spritemap(FALLING_FOOD, 60, 60);
				switch (personNo) {
					case 0:
						spriteMap.add("person1R", [34, 0], 0.1, true);
						spriteMap.play("person1R", true);
						break;
					case 1:
						spriteMap.add("person1L", [1, 2], 0.1, true);
						spriteMap.play("person1L", true);
						break;
					case 2:
						spriteMap.add("person2R", [3, 4], 0.1, true);
						spriteMap.play("person2R", true);
						break;
					case 3:
						spriteMap.add("person2L", [5, 6], 0.1, true);
						spriteMap.play("person2L", true);
						break;
					case 4:
						spriteMap.add("person3R", [7, 8], 0.1, true);
						spriteMap.play("person3R", true);
						break;
					case 5:
						spriteMap.add("person3L", [9, 10], 0.1, true);
						spriteMap.play("person3L", true);
						break;
					case 6:
						spriteMap.add("person4R", [11, 12], 0.1, true);
						spriteMap.play("person4R", true);
						break;
					case 7:
						spriteMap.add("person4L", [13, 14], 0.1, true);
						spriteMap.play("person4L", true);
						break;
					case 8:
						spriteMap.add("person5R", [15, 16], 0.1, true);
						spriteMap.play("person5R", true);
						break;
					case 9:
						spriteMap.add("person5L", [17, 18], 0.1, true);
						spriteMap.play("person5L", true);
						break;
					case 10:
						spriteMap.add("person6R", [19, 20], 0.1, true);
						spriteMap.play("person6R", true);
						break;
					case 11:
						spriteMap.add("person6L", [21, 22 ], 0.1, true);
						spriteMap.play("person6L", true);
						break;
					default:
						spriteMap.add("person1R", [23, 24], 0.1, true);
						spriteMap.play("person1R", true);
						break;
				}
			}
			graphic = spriteMap;
		}
		
		public function Food( gridX : int, gridY : int) 
		{
			personNo = Math.random() * 11;

			_gridX = gridX;
			_gridY = gridY;
			
			falling = true;
			pickPeasant();
			
			x = Arena.gridToPixelsX(_gridX) - 14;
			y = -20;
			
			destX = Arena.gridToPixelsX(_gridX) - 14;
			destY = Arena.gridToPixelsY(_gridY) - 14;
		}
		
		public function setFood ():void {
			x = Arena.gridToPixelsX(_gridX) - 14;
			y = Arena.gridToPixelsY(_gridY) - 14;
			Arena.grid[ _gridX ][ _gridY ] = TileType.FOOD;
		}
		
		override public function update() : void 
		{
			super.update();
			if (falling) {
				FP.stepTowards(this, destX, destY, 15);
				if (x == destX && y == destY ) {
					falling = false;
					setFood ();
					pickPeasant();
					playThud();
					world.add(new SpEffect(destX-70, destY-50));
				}
			}
		}
		
		private function playThud():void {
			var thudSound : int = Math.random() * 3;
			var thud:Sfx;
			switch(thudSound) {
				case 0: 
					thud = new Sfx(FALL1);
					break;
				case 1: 
					thud = new Sfx(FALL2);
					break;
				case 2: 
					thud = new Sfx(FALL3);
					break;
				default:
					break;
			}
			thud.play();
		}

		public function playDeath():void {
			var deathSound : int = Math.random() * 4;
			var death:Sfx;
			switch(deathSound) {
				case 0: 
					death = new Sfx(DEATH1);
					break;
				case 1: 
					death = new Sfx(DEATH2);
					break;
				case 2: 
					death = new Sfx(DEATH3);
					break;
				case 3: 
					death = new Sfx(DEATH4);
					break;
				default:
					break;
			}
			death.play();
			if (world)
				world.add(new SpEffect(destX-70, destY-50, "blood"));
			
		}
		
		override public function removed() : void
		{
		
			if ( Arena.grid[ _gridX ][ _gridY ] == FOOD)
			{
				Arena.grid[ _gridX ][ _gridY ] == TileType.EMPTY;
			}
		}	
	}
}