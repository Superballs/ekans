package
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;

	public class Snake extends Entity
	{
		[ Embed( source = 'assets/snake.png' ) ] public static const SNAKE_MAP : Class;
		[ Embed( source = 'assets/EKANS SOUNDS/snake gets faster.mp3' ) ] private const FASTER : Class;
		
		static public const UP : int = 0;
		static public const RIGHT : int = 1;
		static public const LEFT : int = 2;
		static public const DOWN :int = 3;
		static private var _moveInput : int;
		
		private const BODY_START_LENGTH : int = 5;
		private var body : Vector.< Segment >;
		private var _isMissingTail : Boolean;	

		private const BASELINE_TIME_BETWEEN_MOVING: Number = 0.45
		public var defaultTimeBetweenMoving : Number = BASELINE_TIME_BETWEEN_MOVING;
		private const TIME_BETWEEN_MOVING_FOOD_MODIFIER : Number = 0.025;		
		private var timeBetweenMoving : Number = defaultTimeBetweenMoving;
		private var elapsedTimeSinceLastMove : Number;	
		
		private var movementQueue: Vector.<int>;
	
		private function tileToGridIndex( tile: Tile ): int
		{
			return tile._gridY * Arena.GRID_WIDTH + tile._gridX;
		}
	
		private function gridIndexToTile( index: int ): Tile
		{
			var tempX : int = index % Arena.GRID_WIDTH;
			var tempY : int = (index - tempX) / Arena.GRID_WIDTH;
			return new Tile( tempX, tempY);
		}
		
		public function Snake()
		{
			layer = 4;
			defaultTimeBetweenMoving = BASELINE_TIME_BETWEEN_MOVING;
			
			active = true;
			
			// TODO: determine starting direction
			_moveInput = DOWN;
			elapsedTimeSinceLastMove = 0;
			_isMissingTail = false;
			
			body = new Vector.<Segment>();
		}
				
		override public function added() : void
		{
			// TODO: determine how the snake spawns?!
			for ( var i:int = 0; i < BODY_START_LENGTH; i++)
			{
				var newSegment : Segment = new Segment( new Tile( 0, i) , _moveInput, false );
				newSegment.setHead(false);
				newSegment.setPreviousDirection(_moveInput);
				world.add( newSegment );
				body.unshift(newSegment);							
			}
			body[0].setHead(true);
			body[body.length -1].setTail();
		}
		
		override public function update() : void
		{
			elapsedTimeSinceLastMove += FP.elapsed;
			
			if ( elapsedTimeSinceLastMove > timeBetweenMoving )
			{  
				elapsedTimeSinceLastMove -= timeBetweenMoving;
				
				var targetDirection: int = getAiMove();
				
				if (targetDirection == -1)
				{
					
					targetDirection = _moveInput;	
					var testTile : Tile = getDestinationTile( targetDirection );
					if (!Arena.isValidTile(testTile._gridX, testTile._gridY)) {
											
						for (var dir: int = 0; dir != 4; dir++) {
							var destinationTile : Tile = getDestinationTile( dir );
							switch( dir ) {
								case UP:
									if (targetDirection == DOWN) break;
									if (Arena.isValidTile(destinationTile._gridX, destinationTile._gridY)) {
										targetDirection = UP;
									}
									break;
								case DOWN:
									if (targetDirection == UP) break;
									if (Arena.isValidTile(destinationTile._gridX, destinationTile._gridY)) {
										targetDirection = DOWN;
									}
									break;
								case LEFT:
									if (targetDirection == RIGHT) break;
									if (Arena.isValidTile(destinationTile._gridX, destinationTile._gridY)) {
										targetDirection = LEFT;
										
									}
									break;
								case RIGHT:
									if (targetDirection == LEFT) break;
									if (Arena.isValidTile(destinationTile._gridX, destinationTile._gridY)) {
										targetDirection = RIGHT;
									}
									break;
								default:
									trace("WHAT THA F");
									break;
							}
							if (targetDirection != _moveInput) break;
						}
					}
					/*
					targetDirection = _moveInput;					
					trace( "_moveInput: " + _moveInput );
					var newTile : Tile = getDestinationTile(targetDirection);
					if (newTile._gridY > Arena.GRID_HEIGHT - 2) {
						targetDirection = RIGHT;
						if (newTile._gridY > Arena.GRID_WIDTH - 2 || _moveInput == LEFT) targetDirection = UP;
					}
					if (newTile._gridY < 2) {
						targetDirection = LEFT;
						if (newTile._gridX < 2 || _moveInput == RIGHT) targetDirection = DOWN;
					}
					if (newTile._gridX >= Arena.GRID_WIDTH - 2) {
						targetDirection = UP;
						if (newTile._gridY < 2 || _moveInput == DOWN) targetDirection = LEFT;
					}
					if (newTile._gridX < 2) {
						targetDirection = DOWN;
						if (newTile._gridY > Arena.GRID_HEIGHT - 2 || _moveInput == UP) targetDirection = RIGHT;
					}*/
				}
				
				applyMove(targetDirection);
			}
		}
		
		override public function removed() : void
		{
			for each ( var segment : Segment in body )
			{
				world.remove(segment);
			}		
		}
		
		public function getBody() : Vector.< Segment >
		{
			return body;
		}
		
		private function getAiMove() : int
		{
			return findTarget();
		}
	
		private function applyMove( moveInput : int ) : void
		{
			//if (movementQueue.length)
			//{
				//set _moveInput
			//	_moveInput = movementQueue.shift();
			//}
			_moveInput = moveInput;
			var destinationTile : Tile = getDestinationTile( moveInput );
			
			// TODO: MOVE TO GRID
			var tileType : int = Arena.grid[ destinationTile._gridX ][ destinationTile._gridY ];
			switch (tileType)
			{
				case TileType.FOOD:				
					touchFood( destinationTile );
					break;
					
				case TileType.SNAKE:
					touchSelf( destinationTile );
					break;
				
				case TileType.HERO:
					touchHero( destinationTile );
					break;
				
				case TileType.EMPTY:
					break;

				default:
					//throw
					break;
			}

			if (tileType != TileType.FOOD)
			{
				world.remove( body.pop() );
				body[body.length - 1].setTail();
			}
			var newSegment: Segment = new Segment ( destinationTile, _moveInput );
//TODO: crashing exception: Error #1125: The index 0 is out of range 0.	
			body[0].setHead(false);
			body[0].setPreviousDirection(_moveInput);
			world.add(newSegment);
			body.unshift(newSegment);
			
		}

		private function findTarget() : int
		{
			var visitedGrid: Array;			
			
			var moveMap : Dictionary = new Dictionary(false);
			
			visitedGrid = new Array( Arena.GRID_WIDTH );
			
			const VISITED: int = 0;
			const NOT_VISITED: int = 1;
			
			var openQueue: Vector.< Tile > = new Vector.< Tile >();
			
			for (var x: int = 0; x != Arena.GRID_WIDTH; x++)
			{
				visitedGrid[ x ] = new Array( Arena.GRID_HEIGHT );
				for (var y: int = 0; y != Arena.GRID_HEIGHT; y++)
				{
					visitedGrid[ x ][ y ] = NOT_VISITED;
				}
			}
			
			
			//start at snake's head
			var newTile :Tile = new Tile( body[ 0 ]._gridX, body[ 0 ]._gridY );
			
			visitedGrid[newTile._gridX][newTile._gridY] = VISITED;
			
			openQueue.push(newTile);
			
			// build a spanning tree until we find some food
			var currentTile: Tile;
			while (openQueue.length > 0)
			{				
				currentTile = openQueue.shift();
				var currentTileX: int = currentTile._gridX;
				var currentTileY: int = currentTile._gridY;
				var direction :int = -1;
				
				if (Arena.grid[ currentTileX ][ currentTileY] == TileType.FOOD ||
					Arena.grid[ currentTileX ][ currentTileY] == TileType.HERO) break;
					
				if (body[0]._gridX == currentTileX && body[0]._gridY == currentTileY)
				{
					 direction = _moveInput;
				}

				for (var dir: int = 0; dir != 4; dir++)
				{
					switch( dir ) {
						case UP:
							if (direction == DOWN) break;
							if (!Arena.isValidTile(currentTileX, currentTileY -1)) break;
							if (//Arena.grid[ currentTileX ][ currentTileY - 1 ] != TileType.SNAKE &&
								visitedGrid[ currentTileX ][ currentTileY - 1 ] == NOT_VISITED)
							{
								visitedGrid[ currentTileX ][ currentTileY - 1 ] = VISITED;
								openQueue.push(new Tile(currentTileX, currentTileY - 1));
								moveMap[ tileToGridIndex( new Tile(currentTileX, currentTileY - 1 ) )] = currentTile;
							}
							break;
						case DOWN:
							if (direction == UP) break;
							if (!Arena.isValidTile(currentTileX, currentTileY + 1 )) break;
							if (//Arena.grid[ currentTileX ][ currentTileY + 1 ] != TileType.SNAKE &&
								visitedGrid[ currentTileX ][ currentTileY + 1 ] == NOT_VISITED)
							{
								visitedGrid[ currentTileX ][ currentTileY + 1 ] = VISITED;
								openQueue.push(new Tile(currentTileX, currentTileY + 1));
								moveMap[ tileToGridIndex( new Tile(currentTileX, currentTileY + 1 ) )] = currentTile;
							}
							break;
						case LEFT:
							if (direction == RIGHT) break;
							if (!Arena.isValidTile(currentTileX - 1, currentTileY )) break;
							if (//Arena.grid[ currentTileX - 1][ currentTileY ] != TileType.SNAKE &&
								visitedGrid[ currentTileX - 1][ currentTileY ] == NOT_VISITED)
							{
								visitedGrid[ currentTileX - 1][ currentTileY ] = VISITED;
								openQueue.push(new Tile(currentTileX - 1,currentTileY));
								moveMap[ tileToGridIndex( new Tile(currentTileX - 1, currentTileY ) )] = currentTile;
							}
							break;
						case RIGHT:
							if (direction == LEFT) break;
							if (!Arena.isValidTile(currentTileX + 1, currentTileY )) break;
							if (//Arena.grid[ currentTileX + 1 ][ currentTileY ] != TileType.SNAKE &&
								visitedGrid[ currentTileX + 1 ][ currentTileY ] == NOT_VISITED)
							{
								visitedGrid[ currentTileX + 1 ][ currentTileY ] = VISITED;
								openQueue.push(new Tile(currentTileX + 1, currentTileY ));
								moveMap[ tileToGridIndex( new Tile(currentTileX + 1, currentTileY ) )] = currentTile;
							}
							break;
					}
				}
			}
			
			
			//trace(Arena.grid[currentTileX][currentTileY]);
			movementQueue = new Vector.<int>();
			
			// we couldn't find a path to food/player
			if (Arena.grid[ currentTile._gridX ][ currentTile._gridY ] != TileType.FOOD &&
				Arena.grid[ currentTile._gridX ][ currentTile._gridY ] != TileType.HERO)
			{
				//trace( "random1" );
				/*for (var i: int = 0; i != Arena.GRID_WIDTH; i++)
				{
					var str : String = "";
					for (var j: int = 0; j != Arena.GRID_HEIGHT; j++)
					{
						str += Arena.grid[i][j];
					}
					trace(str);
				}*/
				
				//return getAvailableAdjacentDirection( currentTile );
				return -1
			}
			
			// work backward through the map from the food to our head, building up a queue of directions
			while (moveMap[tileToGridIndex(currentTile)] != undefined) //TODO: Crash here on player
			//while (tileToGridIndex( currentTile ) in moveMap)
			{
				//TODO find out what causes the infinite loop here when the snake touches itself

				var childTile : Tile = moveMap[tileToGridIndex(currentTile)];
				if (childTile._gridX == currentTile._gridX - 1) movementQueue.unshift(RIGHT);
				else if (childTile._gridX == currentTile._gridX + 1) movementQueue.unshift(LEFT);
				else if (childTile._gridY == currentTile._gridY - 1) movementQueue.unshift(DOWN);
				else if (childTile._gridY == currentTile._gridY + 1) movementQueue.unshift(UP);
				else {
					trace("I DUN EXPLODED");
					movementQueue = new Vector.<int>();
				}
				
				currentTile = childTile;
			}
			
			if (movementQueue.length == 0)
			{
				//trace( "random2" );
				//return getAvailableAdjacentDirection(currentTile);
				return -1
			}
			return movementQueue[0];
		}
		
		private function getAvailableAdjacentDirection( currentTile: Tile ) : int
		{
			//double check adjacent tiles, return one that's valid
			for (var dir: int = 0; dir != 4; dir++)
			{
				// can't make a u-turn
				if ((dir == UP && body[0]._direction == DOWN) ||
					(dir == DOWN && body[0]._direction == UP) ||
					(dir == LEFT && body[0]._direction == RIGHT) ||
					(dir == RIGHT && body[0]._direction == LEFT))
				{
					continue;
				}
				
				//if (dir == UP && Arena.grid[ currentTile._gridX ][ currentTile.-1 ]
				if ((dir == UP && currentTile._gridY > 0) ||
					(dir == DOWN && currentTile._gridY < Arena.GRID_HEIGHT-1) ||
					(dir == LEFT && currentTile._gridX > 0) ||
					(dir == RIGHT && currentTile._gridX < Arena.GRID_WIDTH-1))
				{
					return dir;
				}
			}
			//still haven't found anything!
			trace( "Couldn't find an available tile!" );
			return -1;
		}

		private function getDestinationTile( moveInput : int ) : Tile 
		{
			var tile : Tile;
			var gridX : int = body[0]._gridX;
			var gridY : int = body[0]._gridY;
			
			switch ( moveInput )
			{
				case UP:
					gridY--;
					break;

				case DOWN:
					gridY++;
					break;

				case LEFT:
					gridX--;
					break;
				
				case RIGHT:
					gridX++;
					break;
			
				default:
					throw new Error( "Illegal direction argument: " + moveInput );
			}
			
			return new Tile( gridX, gridY );
		}
		
		private function touchFood( foodTile : Tile ) : void 
		{
			//iterate through foods to find the one we just ate
			for ( var i: int = 0; i != Arena.foods.length; i++ )
			{
				if ( Arena.foods[ i ]._gridX == foodTile._gridX &&
					Arena.foods[ i ]._gridY == foodTile._gridY )
				{
					//destroy the food 
					var toDelete: Food  = Arena.foods[ i ];
					toDelete.playDeath();
					world.remove( toDelete );
					
					Arena.foods.splice( i, 1 );
					break;
				}
			}
			
			_isMissingTail = false;
		}
		
		// I don't know about anybody else. When I think about you I touch myself.
		private function touchSelf( destinationTile: Tile ): void
		{
			//find segment index that got eaten
			var eatenID : int = 1; //Don't test for collision of head with head
			while (eatenID != body.length)
			{
				if (destinationTile._gridX == body[ eatenID ]._gridX &&
						destinationTile._gridY == body[ eatenID ]._gridY)
				{
					// TODO: causing a crash!!!!
					trace( "Eating self! At segment: " + eatenID );
					break;
				}
				eatenID++;
			}
			
			
			if (world && eatenID != body.length) world.add(new SpEffect(Arena.gridToPixelsX(body[ eatenID ]._gridX) - 85+20, 
							Arena.gridToPixelsY(body[ eatenID ]._gridY)-85+20, "bloodspot"));
			
			
			//destroy discarded tail segments - the eaten one until the end
			var pieces : int = 0;
			while (body.length > eatenID)
			{
				pieces++;
				eatOwnSegment(eatenID);		
			}
			timeBetweenMoving = defaultTimeBetweenMoving;
			if ( Main._gameStatus == GameStatus.PLAYING )
			{	
				Score.addSnakePiecesToScore( pieces );
			}
			_isMissingTail = true;
			modifySpeed( true );
		}

		private function touchHero( destinationTile: Tile ): void		
		{
			Main.endGame();
		}
	
		// This method is what happens to a segment that gets eaten. At the
		// moment, it just destroys the segment, but this is where we'd put
		// animation, or it turning into acid, or whatever.
		private function eatOwnSegment( segmentID: int ): void
		{
			Arena.grid[ body[ segmentID ]._gridX ][ body[ segmentID ]._gridY ] = TileType.EMPTY
			if (world) world.add(new SpEffect(Arena.gridToPixelsX(body[ segmentID ]._gridX) - 80, 
							Arena.gridToPixelsX(body[ segmentID ]._gridY)+40, "blood"));

			world.remove( body[ segmentID ] );
			body.splice( segmentID, 1 );
			
		}
		
		public function modifySpeed( reset : Boolean ) : void
		{
			timeBetweenMoving = (reset) ? defaultTimeBetweenMoving : (timeBetweenMoving - TIME_BETWEEN_MOVING_FOOD_MODIFIER);
		}
		
		public function isMissingTail() : Boolean
		{
			return _isMissingTail;
		}
		
		public function playModifySpeedSound() : void
		{
			var faster : Sfx = new Sfx( FASTER );
			faster.play();			
		}	
	}
}