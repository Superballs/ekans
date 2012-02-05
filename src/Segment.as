package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;


	public class Segment extends Entity
	{
		//[ Embed( source = 'assets/body.JPG' ) ] private const BODY : Class;
		public var snakeSprite : Spritemap = new Spritemap(Snake.SNAKE_MAP, 40, 40);
		public var _gridX : int;
		public var _gridY : int;
		public var _direction : int;
		public var _preDir : int;
		public var isTail : Boolean;
		public var isHead : Boolean;
		
		/*
		private var blurAlpha:Number = 0.95;
		private var blurBuffer:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, true, 0);
		private var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, blurAlpha);*/
		
		private function initSpriteMap():void {
			snakeSprite.add("right", [0, 1], 0.03, true);
			snakeSprite.add("left", [24, 25], 0.03, true);
			snakeSprite.add("down", [12, 13], 0.03, true);
			snakeSprite.add("up", [36, 37], 0.03, true);
			
			snakeSprite.add("downleft", [2, 3], 0.03, true);
			snakeSprite.add("upleft", [4, 5], 0.03, true);
			snakeSprite.add("rightdown", [14, 15], 0.03, true);
			snakeSprite.add("leftdown", [16, 17], 0.03, true);
			
			snakeSprite.add("upright", [26, 27], 0.03, true);
			snakeSprite.add("downright", [28, 29], 0.03, true);			
			snakeSprite.add("leftup", [38, 39], 0.03, true);
			snakeSprite.add("rightup", [40, 41], 0.03, true);
		
			snakeSprite.add("headAppearDown", [48], 0.2, false);
			snakeSprite.add("headAppearUp", [60], 0.06, false);
			snakeSprite.add("headAppearLeft", [52], 0.06, false);
			snakeSprite.add("headAppearRight", [64], 0.06, false);
			/*
			snakeSprite.add("headleftdown", [54], 0.03, true);
			snakeSprite.add("headrightdown", [55], 0.03, true);
			snakeSprite.add("headleftup", [56], 0.03, true);
			snakeSprite.add("headrightup", [57], 0.03, true);
			
			snakeSprite.add("headdownright", [66], 0.03, true);	
			snakeSprite.add("headdownleft", [67], 0.03, true);
			snakeSprite.add("headupright", [68], 0.03, true);
			snakeSprite.add("headupleft", [69], 0.03, true);
			*/
					
			snakeSprite.add("tailAppearDown", [42], 0.2, false);
			snakeSprite.add("tailAppearUp", [18], 0.06, false);
			snakeSprite.add("tailAppearLeft", [6], 0.06, false);
			snakeSprite.add("tailAppearRight", [30], 0.06, false);
			
			snakeSprite.add("tailleftdown", [43], 0.03, true);
			snakeSprite.add("tailrightdown", [44], 0.03, true);
			snakeSprite.add("tailleftup", [20], 0.03, true);
			snakeSprite.add("tailrightup", [19], 0.03, true);
			
			snakeSprite.add("taildownright", [31], 0.03, true);	
			snakeSprite.add("taildownleft", [8], 0.03, true);
			snakeSprite.add("tailupright", [32], 0.03, true);
			snakeSprite.add("tailupleft", [7], 0.03, true);
			
			
			snakeSprite.add("stumpAppearDown", [45], 0.2, false);//
			snakeSprite.add("stumpAppearUp", [21], 0.06, false);//
			snakeSprite.add("stumpAppearLeft", [9], 0.06, false);//
			snakeSprite.add("stumpAppearRight", [33], 0.06, false);//
			
			snakeSprite.add("stumpleftdown", [47], 0.03, true);//
			snakeSprite.add("stumprightdown", [46], 0.03, true);//
			snakeSprite.add("stumpleftup", [22], 0.03, true);//
			snakeSprite.add("stumprightup", [23], 0.03, true);//
			
			snakeSprite.add("stumpdownright", [35], 0.03, true);//	
			snakeSprite.add("stumpdownleft", [10], 0.03, true);//
			snakeSprite.add("stumpupright", [34], 0.03, true);//
			snakeSprite.add("stumpupleft", [11], 0.03, true);//
		}
		
		public function UpdateSprite():void {
			if (_preDir == Snake.DOWN && _direction == Snake.DOWN && isHead == true) {
				snakeSprite.play("headAppearDown", true);
			} else if (_preDir == Snake.UP && _direction == Snake.UP && isHead == true) {
				snakeSprite.play("headAppearUp", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.LEFT && isHead == true) {
				snakeSprite.play("headAppearLeft", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.RIGHT && isHead == true) {
				snakeSprite.play("headAppearRight", true);
			} 
			/*else if (_preDir == Snake.LEFT && _direction == Snake.DOWN && isHead == true) {
				snakeSprite.play("headdownleft", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.UP && isHead == true) {
				snakeSprite.play("headupleft", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.RIGHT && isHead == true) {
				snakeSprite.play("headrightdown", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.LEFT && isHead == true) {
				snakeSprite.play("headleftdown", true);
			} 
			else if (_preDir == Snake.RIGHT && _direction == Snake.UP && isHead == true) {
				snakeSprite.play("headupright", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.DOWN && isHead == true) {
				snakeSprite.play("headdownright", true);
			} else if (_preDir == Snake.UP && _direction == Snake.LEFT && isHead == true) {
				snakeSprite.play("headleftup", true);
			} else if (_preDir == Snake.UP && _direction == Snake.RIGHT && isHead == true) {
				snakeSprite.play("headrightup", true);
			} */
			else if (_preDir == Snake.DOWN && _direction == Snake.DOWN && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpAppearDown", true);
			} else if (_preDir == Snake.UP && _direction == Snake.UP && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpAppearUp", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.LEFT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpAppearLeft", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.RIGHT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpAppearRight", true);
			} 
			else if (_preDir == Snake.LEFT && _direction == Snake.DOWN && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpdownleft", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.UP && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpupleft", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.RIGHT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumprightdown", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.LEFT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpleftdown", true);
			} 
			else if (_preDir == Snake.RIGHT && _direction == Snake.UP && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpupright", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.DOWN && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpdownright", true);
			} else if (_preDir == Snake.UP && _direction == Snake.LEFT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumpleftup", true);
			} else if (_preDir == Snake.UP && _direction == Snake.RIGHT && isTail == true && Arena.getSnake().isMissingTail()) {
				snakeSprite.play("stumprightup", true);
			}
			
			
			else if (_preDir == Snake.DOWN && _direction == Snake.DOWN && isTail == true) {
				snakeSprite.play("tailAppearDown", true);
			} else if (_preDir == Snake.UP && _direction == Snake.UP && isTail == true) {
				snakeSprite.play("tailAppearUp", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.LEFT && isTail == true) {
				snakeSprite.play("tailAppearLeft", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.RIGHT && isTail == true) {
				snakeSprite.play("tailAppearRight", true);
			} 
			else if (_preDir == Snake.LEFT && _direction == Snake.DOWN && isTail == true) {
				snakeSprite.play("taildownleft", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.UP && isTail == true) {
				snakeSprite.play("tailupleft", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.RIGHT && isTail == true) {
				snakeSprite.play("tailrightdown", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.LEFT && isTail == true) {
				snakeSprite.play("tailleftdown", true);
			} 
			else if (_preDir == Snake.RIGHT && _direction == Snake.UP && isTail == true) {
				snakeSprite.play("tailupright", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.DOWN && isTail == true) {
				snakeSprite.play("taildownright", true);
			} else if (_preDir == Snake.UP && _direction == Snake.LEFT && isTail == true) {
				snakeSprite.play("tailleftup", true);
			} else if (_preDir == Snake.UP && _direction == Snake.RIGHT && isTail == true) {
				snakeSprite.play("tailrightup", true);
			} //End tail
			else if (_direction == Snake.UP && _preDir == Snake.UP) {
				snakeSprite.play("up", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.DOWN) {
				snakeSprite.play("down", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.LEFT) {
				snakeSprite.play("left", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.RIGHT) {
				snakeSprite.play("right", true);
			} 
			else if (_preDir == Snake.LEFT && _direction == Snake.DOWN) {
				snakeSprite.play("downleft", true);
			} else if (_preDir == Snake.LEFT && _direction == Snake.UP) {
				snakeSprite.play("upleft", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.RIGHT) {
				snakeSprite.play("rightdown", true);
			} else if (_preDir == Snake.DOWN && _direction == Snake.LEFT) {
				snakeSprite.play("leftdown", true);
			} 
			else if (_preDir == Snake.RIGHT && _direction == Snake.UP) {
				snakeSprite.play("upright", true);
			} else if (_preDir == Snake.RIGHT && _direction == Snake.DOWN) {
				snakeSprite.play("downright", true);
			} else if (_preDir == Snake.UP && _direction == Snake.LEFT) {
				snakeSprite.play("leftup", true);
			} else if (_preDir == Snake.UP && _direction == Snake.RIGHT) {
				snakeSprite.play("rightup", true);
			} 
		}
		
		public function setPreviousDirection(direction : int):void {
			_preDir = direction;
			UpdateSprite();
		}
		
		public function setHead (head : Boolean ):void {
			isHead = head;
			UpdateSprite();
		}
		
		public function setTail():void {
			isTail = true;
			UpdateSprite();
		}
		
		public function Segment( tile : Tile, direction : int , head :Boolean = true )
		{			
		//graphic = new Image( BODY );

			_gridX = tile._gridX;
			_gridY = tile._gridY;
			
			_direction = direction;
			_preDir = direction;
			isHead = head;
			isTail = false;
			initSpriteMap();

			UpdateSprite();
						
			graphic = snakeSprite;
			layer = -2;
			
			Arena.grid[ _gridX ][ _gridY ] = TileType.SNAKE;
			
			x = Arena.gridToPixelsX(_gridX);//_gridX * Arena.GRID_SIZE;
			y = Arena.gridToPixelsY(_gridY);//_gridY * Arena.GRID_SIZE;
		}
		/*
		override public function render():void
		{
			blurBuffer.colorTransform(blurBuffer.rect, colorTransform);
			Draw.setTarget(blurBuffer, FP.camera);
			Draw.graphic(graphic, x, y);
			Draw.resetTarget();
			FP.buffer.copyPixels(blurBuffer, blurBuffer.rect, FP.zero, null, null, true);
		}*/

		override public function removed():void {
			Arena.grid[ _gridX ][ _gridY ] = TileType.EMPTY;
		}
	}
}