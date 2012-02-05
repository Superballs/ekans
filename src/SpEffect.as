package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.TiledSpritemap;

	
	
	public class SpEffect extends Entity
	{
		
		[ Embed( source = 'assets/dustclouds.png' ) ] private const DUSTCLOUD : Class;
		[ Embed( source = 'assets/blood_splatter.png' ) ] private const BLOODSPLATTER : Class;
		[ Embed( source = 'assets/blooooood.png' ) ] private const BLOOD : Class;
		[ Embed( source = 'assets/orb.png' ) ] private const ORB : Class;
	
		private var spriteMap : Spritemap;
		
		public function SpEffect(_x : int, _y : int, type : String = "dirt")
		{
			
			x = _x;
			y = _y;
			if (type == "dirt") {
				spriteMap = new Spritemap(DUSTCLOUD, 200, 200, aniComplete);
				spriteMap.add("dirt", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 1, true);
				spriteMap.play("dirt", true);
			} else if (type == "blood") {
				spriteMap = new Spritemap(BLOODSPLATTER, 200, 200, aniComplete);
				spriteMap.add("dirt", [17,0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 0.7, true);
				spriteMap.play("dirt", true);
			} else if (type == "aura") {
				spriteMap = new Spritemap(ORB, 100, 400, aniComplete);
				spriteMap.add("orb", [20, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 0.7, true);
				spriteMap.play("orb", true);
				
			} else if (type == "bloodspot") {
				
				spriteMap = new Spritemap( BLOOD, 170, 170, aniComplete);
				spriteMap.add("bloodStain1", [59, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], .05, true );
				spriteMap.add("bloodStain2", [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38], .05, true );
				spriteMap.add("bloodStain3", [39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58], .05, true );
				switch( int(Math.random() *3 )) {
					case 0:
						spriteMap.play("bloodStain1", true );
					case 1:
						spriteMap.play("bloodStain2", true );
					case 2:
						spriteMap.play("bloodStain3", true );
				}				
			}
			
			graphic = spriteMap;
			layer = -3;
			if (type == "bloodspot")
			{
				layer = -1;
			}
		}
		
		private function aniComplete () :void {
			world.remove(this);
		}
	}

}