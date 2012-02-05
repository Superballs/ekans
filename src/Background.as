package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	public class Background extends Entity
	{		
		[ Embed( source = 'assets/arena.png' ) ] public const ARENA_BG: Class;
		public function Background() 
		{
			graphic = new Image(ARENA_BG);
			layer = 100;
		}		
	}

}