tool
extends Spatial

export var GroundScene: PackedScene
export var ObstacleScene: PackedScene

export(int, 1, 21) var map_width = 11 setget set_width
export(int, 1, 15) var map_depth = 11 setget set_depth

export(float, 0, 1, 0.05) var obstacle_density = 0.2 setget set_obstacle_density

export(float, 1, 5) var obstacle_max_height = 5 setget set_max_obs_height
export(float, 1, 5) var obstacle_min_height = 1 setget set_min_obs_height

export(int) var rng_seed = 12345 setget set_seed

var map_coords_array := []

class Coord:
	var x: int
	var z: int
	
	func _init(x, z):
		self.x = x
		self.z = z
		
	func _to_string():
		# (x, z)
		return "(" + str(x) + ", " + str(z) + ")"

func _ready():
	generate_map()
	
func set_max_obs_height(new_val):
	obstacle_max_height = max(new_val, obstacle_min_height)
	generate_map()

func set_min_obs_height(new_val):
	obstacle_min_height = min(new_val, obstacle_max_height)
	generate_map()
	
func set_seed(var new_val):
	rng_seed = new_val
	generate_map()
	
func set_width(var new_val):
	map_width = make_odd(new_val, map_width)
	generate_map()
	
func set_depth(var new_val):
	map_depth = make_odd(new_val, map_depth)
	generate_map()
	
func set_obstacle_density(new_val):
	obstacle_density = new_val
	generate_map()
	
func make_odd(new_int, old_int):
	if new_int % 2 == 0: # it's even
		if new_int > old_int:
			return new_int + 1
		else:
			return new_int - 1
	else: # it's already odd
		return new_int
		
func fill_map_coords_array():
	map_coords_array = []
	for x in range(map_width):
		for z in range(map_depth):
			map_coords_array.append(Coord.new(x, z))
	
func generate_map():
	print("Bleep bloop generating map...")
	
	clear_map()
	add_ground()
	add_obstacles()
	
func clear_map():
	for node in get_children():
		node.queue_free()
		
func add_ground():
	var ground: CSGBox = GroundScene.instance()
	ground.width = map_width * 2
	ground.depth = map_depth * 2 
	add_child(ground)
	
func add_obstacles():
	fill_map_coords_array()
#	print(map_coords_array)
	seed(rng_seed)
	map_coords_array.shuffle()
#	print(map_coords_array)
	
	var num_obstacles: int = map_coords_array.size() * obstacle_density
	
	if num_obstacles > 0:
		for coord in map_coords_array.slice(0, num_obstacles - 1):
			create_obstacle_at(coord.x, coord.z)


func create_obstacle_at(x, z):
	var obstacle_position = Vector3(x * 2, 0, z * 2)
	obstacle_position += Vector3(-map_width + 1, 0, -map_depth + 1)
	var new_obstacle: CSGBox = ObstacleScene.instance()
	new_obstacle.height = get_obstacle_height()
	new_obstacle.transform.origin = obstacle_position + Vector3(0, new_obstacle.height/2, 0)
	add_child(new_obstacle)

func get_obstacle_height():
	return rand_range(obstacle_min_height, obstacle_max_height)
	
