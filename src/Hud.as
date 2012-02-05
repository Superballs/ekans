package  
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	public class Hud extends Entity
	{
		[ Embed( source = 'assets/title.png' ) ] private const TITLE: Class;
		[ Embed( source = 'assets/game_over.png' ) ] private const GAME_OVER: Class;
		[ Embed( source = 'assets/BloodyStump.ttf', embedAsCFF = "false", fontFamily = 'scoreFont' ) ] private const newFont : Class;
		
		private const HIGH_SCORE_PREFIX : String = "HIGH SCORE: ";
		private const SCORE_PREFIX : String = "SCORE: ";
		
		private var _gameOver : Image; 
		private var _score : Text;
		private var _highScore : Text;
		private var _pressSpace : Text
		
		private var _alphaFadeFactor : int;
		private var _currentScore : int;
		private var _scoreFontSize : int;

		public function Hud()
		{
			layer = -4;
			Text.font = "scoreFont";

			var title : Image = new Image( TITLE, new Rectangle( -40, -170, 984, 1020 ) );
			_gameOver = new Image( GAME_OVER, new Rectangle( -40, -200, 984, 1050 ) );			

			_highScore = new Text( "", 40, 130 );
			_highScore.color = 0x74462E;
			_highScore.size = 28;

			_score = new Text( "", 680, 130 );
			_score.color = 0x74462E;
			_score.size = 28;

			_pressSpace = new Text( "PRESS SSSPACE TO SUMMON SATO...", 190, 710 );
			_pressSpace.color = 0x74462E;
			_pressSpace.size = 32;
			_pressSpace.alpha = 1;
			_alphaFadeFactor = -1;
			
			graphic = new Graphiclist( title, _highScore, _score, _pressSpace );
			layer = -3;
		}

		override public function update() : void 
		{
			updateDisplayedScore();
			applyEffects();
			
			if ( Input.check( Key.SPACE ) ) 
			{
				switch( Main._gameStatus )
				{
					case GameStatus.TITLE:
						startGame();
						break;
						
					case GameStatus.PLAYING:						
						break;
						
					case GameStatus.GAME_OVER:
						startGame();
						break;
						
					default:
						// TODO: throw illegal args
						break;
				}
			}
		}
		
		private function startGame() : void
		{
			Main.startGame();
			Score.resetScore();
			graphic = new Graphiclist( _highScore, _score );
		}
		
		private function updateDisplayedScore() : void
		{
			// TODO: refactor this hackery one day
			var newScore : int = Score.getScore();
			_score.text = SCORE_PREFIX + String(newScore);
			_highScore.text = HIGH_SCORE_PREFIX + String(Score.getHighScore());
			var scoreDifference : int = newScore - _currentScore;
			if (scoreDifference > 0)
			{
				if (scoreDifference < 400)
				{
					_score.size = 36;
				}
				else if (scoreDifference < 1000)
				{
					_score.size = 42;				
				}
				else if (scoreDifference < 1200)
				{
					_score.size = 48;
				}
				else
				{
					_score.size = 56;
				}
			}
			_currentScore = newScore;
		}
		
		public function showGameOver() : void
		{
			graphic = new Graphiclist( _gameOver, _highScore, _score, _pressSpace );
		}
		
		public function applyEffects() : void
		{
			var rate : Number = 0.01;		
			var adjust : Number = (_alphaFadeFactor * rate);

			_pressSpace.alpha += adjust;
			if ( _pressSpace.alpha <= 0.3 )
			{
				_alphaFadeFactor = 1;
			}
			else if ( _pressSpace.alpha >= 0.9 )
			{
				_alphaFadeFactor = -1;
			}
			
			if (_score.size > 28)
			{
				_score.size--;
			}
		}
	}
}