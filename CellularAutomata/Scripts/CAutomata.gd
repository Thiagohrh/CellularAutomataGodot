extends Node2D

export(int) var width
export(int) var height
export(PackedScene) var wallSprite

var spriteDimentions = 16
var string_seed

var bool_use_random_seed

export(int, 100) var randomFillPercent

var map = Array()

func _ready():
	map.resize(width)
	for i in range(map.size()):
		var new_array = Array()
		new_array.resize(height)
		map[i] = new_array
		pass
	
	#Test to see if it can access any position through expressions like:
	#map[2][3] or whatever.... that will make things easier.
	GenerateMap()
	#In order to actually spawn the map....
	SpawnSprites()
	pass

func GenerateMap():
	#Use this function in order to start the map
	if map != null:
		for i in map:
			i.clear()
			i = null
		map.clear()
		
		map = Array()
		map.resize(width)
		for i in range(map.size()):
			var new_array = Array()
			new_array.resize(height)
			map[i] = new_array
		pass
	
	#First part of the magic
	RandomFillMap()
	#Second part of the magic. This should have a variable state in order to control how many times it will apply the cicle.
	for i in range(10):
		SmoothMap()
	pass

func RandomFillMap():
	#Use this function in order to start all the map with random positions everywhere.
	randomize()
	
	for x in range(width):
		for y in range(height):
			if x == 0 || x == width-1 || y == 0 || y == height -1:
				map[x][y] = 1;
				pass
			else:
				var random_number = randi() % 100
				if random_number < randomFillPercent:
					map[x][y] = 1
				else:
					map[x][y] = 0
				pass
			pass
		pass
	
	
	
	#This is the end of the function...
	pass

func SmoothMap():
	#Use this to apply the rules of smoothing, acoording to the MapOfLive Algorithm seen in:
	#https://unity3d.com/pt/learn/tutorials/projects/procedural-cave-generation-tutorial/cellular-automata
	for x in range(width):
		for y in range(height):
			var neighbourWallTiles = GetSurroundingWallCount(x,y)
			
			if neighbourWallTiles > 4:
				map[x][y] = 1
				pass
			elif neighbourWallTiles < 4:
				map[x][y] = 0
			
			pass
		pass
	
	
	#This is the end of the function!
	pass

func GetSurroundingWallCount(gridX, gridY):
	#Use this function to check how many walls are around the target tile (coordinates: x and y)
	var wallCount = 0
	#for i in range(2, 5):
	#	print(i)
	
	for neighbourX in range(gridX - 1, gridX + 2):
		for neighbourY in range(gridY - 1, gridY + 2):
			if neighbourX >= 0 && neighbourX < width && neighbourY >= 0 && neighbourY < height:
				if neighbourX != gridX || neighbourY != gridY:
					wallCount += map[neighbourX][neighbourY]
				pass
			else:
				wallCount += 1
				pass
			pass
		pass
	
	#This is the end of the function
	return wallCount

#Needs a function to draw the whole shebang, like a OnDrawGizmos on unity, but instead it should spawn the map.
func SpawnSprites():
	for x in range(width):
		for y in range(height):
			
			if map[x][y] == 1:
				#If there is supposed to be a wall here.....hmmm...
				var new_sprite = wallSprite.instance()
				$VisualMapHolder.add_child(new_sprite)
				
				new_sprite.global_position.x = 0 + x * 16
				new_sprite.global_position.y = 0 + y * 16
				pass
			pass
		pass
	pass