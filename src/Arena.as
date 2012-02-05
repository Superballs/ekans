package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.Sfx;
	import net.flashpunk.FP;

	public class Arena extends World
	{
		public static const GRID_SIZE: int = 40;
		public static const TOP_OF_SCREEN_OFFSET : int = 156;
		public static const X_SCREEN_OFFSET : int = 35;
		public static const GRID_WIDTH: int = 960 / GRID_SIZE;
		public static const GRID_HEIGHT: int = 560 / GRID_SIZE;
		
		static public function gridToPixelsX(_gridX : int) : int {
			var tx : int = _gridX * GRID_SIZE + X_SCREEN_OFFSET;
			return tx;
		}
		
		static public function gridToPixelsY(_gridY : int) : int {
			var ty : int = _gridY * GRID_SIZE + TOP_OF_SCREEN_OFFSET;
			return ty;
		}
		
		[ Embed( source = 'assets/Ekans_theme-V01.mp3' ) ] private const MUSIC:Class;
		
		private var _grid: Array;

		static private var _hud : Hud;
		static private var _hero : Hero;
		static private var _snake : Snake;
		static private var _crowd : Crowd;
		static private var _pharoah : Pharoah;
		private var _foodMaker : FoodMaker;
		
		public static var foods : Vector.<Food>;
		
		public var music:Sfx = new Sfx(MUSIC);
		
		public static var grid: Array;
		
		private var background: Background;
		
		public function Arena()
		{
			_hud = new Hud();
			add( _hud );
			

			//TODO uncomment this
			music.loop();
			
			background = new Background( );
			add( background );
			
			//add (new Crowd);
			_crowd = new Crowd();
			add (_crowd);
			
			_pharoah = new Pharoah();
			add (_pharoah);
			//_pharoah.playAnimation();
			
			foods = new Vector.<Food>;
			grid = new Array( GRID_WIDTH );
			for (var tx: int = 0; tx != GRID_WIDTH; tx++)
			{
				grid[ tx ] = new Array( GRID_HEIGHT );
				for (var ty: int = 0; ty != GRID_HEIGHT; ty++)
				{
					grid[ tx ][ ty ] = TileType.EMPTY;
				}
			}
		}
		
		static public function getSnake() : Snake
		{
			return _snake;
		}
		
		static public function getHero() : Hero
		{
			return _hero;
		}
		
		static public function getCrowd() : Crowd
		{
			return _crowd;
		}
		
		static public function getPharoah() : Pharoah
		{
			return _pharoah;
		}
		
		public function initialiseGame() : void
		{			
			if ( _hero != null )
			{
				remove( _hero );
			}
			
			_hero = new Hero( 20, 4 );
			add( _hero );	
			
			if ( _snake != null )
			{
				remove( _snake );
			}
			
			_snake = new Snake();
			add( _snake );
					
			if ( _foodMaker != null )
			{
				remove( _foodMaker );
			}
			
			_foodMaker = new FoodMaker();
			add( _foodMaker );
		}
		
		public function finaliseGame() : void
		{
			_hud.showGameOver();

			if ( _hero != null )
			{
				remove( _hero );
			}		
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		static public function getTileType( tile : Tile ) : int
		{
			// TODO: trap error
			return Arena.grid[ tile._gridX ][ tile._gridY ]
		}		
		
		static public function isValidTile(gridX : int, gridY : int ) : Boolean
		{
			if (gridX < 0 || gridX >= GRID_WIDTH || gridY < 0 || gridY >= GRID_HEIGHT) return false;
			return true;
		}
	}
}