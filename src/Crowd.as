package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;

	public class Crowd extends Entity
	{
		[ Embed( source = 'assets/crowd.png') ] private const CROWD : Class;
		[ Embed( source = 'assets/crowd_clap.png') ] private const CROWD_CLAP : Class;
		[ Embed( source = 'assets/crowd_cheer.png') ] private const CROWD_CHEER : Class;
		[ Embed( source = 'assets/EKANS SOUNDS/crowd noise loop.mp3' ) ] private const CHEER:Class;
		
		static private const CUTOFF_SILENT : int = 0;
		static private const CUTOFF_CLAP : int = 1000;
		static private const CUTOFF_CHEER : int = 5000;
		
		static private const ENUM_SILENT: int = 0;
		static private const ENUM_CLAP: int = 1;
		static private const ENUM_CHEER: int = 2;

		private var spriteMap : Spritemap;
		private var currentSpriteSheet : int;
		
		public function setSilent():void {
			spriteMap = new Spritemap(CROWD, 900, 200);
			graphic = spriteMap;
			currentSpriteSheet = ENUM_SILENT;
		}
		
		public function setClap():void {
			spriteMap = new Spritemap(CROWD_CLAP, 900, 200);
			spriteMap.add("clap", [0, 1,2,3,4,5,6,7,8,9], 0.5, true);
			spriteMap.play("clap", true);
			graphic = spriteMap;
			currentSpriteSheet = ENUM_CLAP;
		}
		
		public function setCheer():void {
			spriteMap = new Spritemap(CROWD_CHEER, 900, 200);
			spriteMap.add("cheer", [0, 1,2,3,4,5,6,7,8,9], 0.5, true);
			spriteMap.play("cheer", true);
			graphic = spriteMap;
			currentSpriteSheet = ENUM_CHEER;
		}
		
		public function Crowd() 
		{
			x = 70;
			y = -45;
			spriteMap = new Spritemap(CROWD, 900, 200);
			graphic = spriteMap;
			currentSpriteSheet = ENUM_SILENT;
		}
		
		public function updateSprites(): void
		{
			if (currentSpriteSheet != ENUM_CHEER && Score.getScore() > CUTOFF_CHEER)
			{
				setCheer();
			}
			else if (currentSpriteSheet == ENUM_SILENT && Score.getScore() > CUTOFF_CLAP)
			{
				setClap();
			}
		}

		override public function update() : void 
		{
			super.update();
		}
		

		public function playCheer():void {
			var cheer:Sfx = new Sfx(CHEER);
			cheer.play();
			
		}

	}
}