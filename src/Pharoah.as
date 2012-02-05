package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class Pharoah extends Entity
	{
		[ Embed( source = 'assets/pharoah_pound.png') ] private const PHAROAH : Class;
		private var spriteMap : Spritemap;
		
		public function Pharoah() 
		{
			x = 416;
			y = -24;
			spriteMap = new Spritemap(PHAROAH, 180, 180);
			spriteMap.add("pound", [36, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
				21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35], 0.5, false);
			//spriteMap.setFrame(37);
			spriteMap.setAnimFrame("pound", 36);
			graphic = spriteMap;
		}
		
		public function playAnimation():void {
			spriteMap.play("pound", true );
		}
	}

}