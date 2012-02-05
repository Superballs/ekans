package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.TiledSpritemap;

	
	
	public class SmokeCloud extends Entity
	{
		
		[ Embed( source = 'assets/dustclouds.png' ) ] private const DUSTCLOUD : Class;
		[ Embed( source = 'assets/blood_splatter.png' ) ] private const BLOODSPLATTER : Class;
	
		private var spriteMap : Spritemap;
		
		public function SmokeCloud(_x : int, _y : int, type : String = "dirt")
		{
			x = _x;
			y = _y;
			if (type == "dirt") {
				spriteMap = new Spritemap(DUSTCLOUD, 200, 200, aniComplete);
				spriteMap.add("dirt", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 1, true);
				spriteMap.play("dirt", true);
			} else {
				spriteMap = new Spritemap(BLOODSPLATTER, 200, 200, aniComplete);
				spriteMap.add("dirt", [17,0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 1, true);
				spriteMap.play("dirt", true);
			}
			graphic = spriteMap;
		}
		
		private function aniComplete () :void {
			world.remove(this);
		}
	}

}