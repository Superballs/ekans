package
{
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.Screen;
	import net.flashpunk.FP;
	import flash.events.Event;
	import net.flashpunk.World;

	public class Main extends Engine
	{
		public static const WINDOW_WIDTH : int = 1024;
		public static const WINDOW_HEIGHT : int = 768;
		
		public static var _arena : Arena;
		public static var _score : Score;
		public static var _gameStatus : int;
		
		public function Main()
		{		
			super( WINDOW_WIDTH, WINDOW_HEIGHT, 60, true );			
			 
			_arena = new Arena;
			FP.world = _arena;
			_score = new Score;
			_gameStatus = GameStatus.TITLE;
		}

		public static function getScore() : Score
		{
			return _score;
		}
		
		public static function startGame() : void
		{
			_gameStatus = GameStatus.PLAYING;
			_arena.initialiseGame(); 
		}

		public static function endGame() : void
		{
			_gameStatus = GameStatus.GAME_OVER;
			_arena.finaliseGame();			
		}
		
		override public function init(): void
		{
			trace("FlashPunk has started successfully!");
		}
	}
}