package  
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	public class Score extends Entity
	{
		static private const RESCUE_POINTS : int = 1000;
		static private const SNAKE_PIECE_POINTS : int = 100;
		static private const STUMPY_MULTIPLIER : int = 10;
		
		static private var _score : int;
		static private var _highScore : int;
		
		static public function getScore() : int
		{
			return _score;
		}

		static public function getHighScore() : int
		{
			return _highScore;
		}
		
		static public function resetScore() : void
		{
			_score = 0;
		}
		
		static public function adjustScore( change: int ): void
		{
			/*
			const SCORE_CHANGE_FOR_SPEED_INCREASE: int = 10000;  //how many points the player must get
			const SNAKE_SPEED_INCREASE_RATE: Number = 1.1 //how much faster he gets
			
			var numInstantIncreases: int = int(change / SCORE_CHANGE_FOR_SPEED_INCREASE);
			for (var i: int = 0; i != numInstantIncreases; i++)
			{
				Arena.getSnake().defaultTimeBetweenMoving /= 1.1;
			}
			
			if (_score           % SCORE_CHANGE_FOR_SPEED_INCREASE !=
			   (_score - (numInstantIncreases * SCORE_CHANGE_FOR_SPEED_INCREASE) + change) % SCORE_CHANGE_FOR_SPEED_INCREASE)
			{
				Arena.getSnake().defaultTimeBetweenMoving /= 1.1;
			}
			*/
			
			_score += change;
			updateHighScore();
			Arena.getCrowd().updateSprites();
		}
		
		static public function addRescueToScore() : void
		{
			adjustScore( RESCUE_POINTS );
		}
		
		static public function addSnakePiecesToScore( pieces : int ) : void
		{
			var baseScore : int = pieces * SNAKE_PIECE_POINTS;
			var multiplier : int = getMultiplier();
			
			adjustScore( baseScore * multiplier );
		}

		static private function updateHighScore() : void
		{
			_highScore = ( _highScore >= _score ) ? _highScore : _score;
		}
		
		static private function getMultiplier() : int
		{
			return ( Arena.getSnake().isMissingTail() ) ? STUMPY_MULTIPLIER : 1;
		}
	}
}