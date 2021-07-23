extends Navigation

class_name NavigationMap

const CELL_SIZE = 2

var map_coords_array := []
var random_map_coords := []

export(Array, Array) var obstacle_map := []
var map_center: Coord

export(int) var map_width
export(int) var map_depth 

class Coord:
	var x: int
	var z: int
	
	func _init(x, z):
		self.x = x
		self.z = z
		
	func _to_string():
		# (x, z)
		return "(" + str(x) + ", " + str(z) + ")"
		
	func equals(coord):
		return coord.x == self.x and coord.z == self.z
		
func get_waves():
	return $Waves.get_children()

func _ready():
	fill_map_coords_array()
	fill_random_map_coords()
	
func update_map_center():
	map_center = Coord.new(map_width/2, map_depth/2)
	
func fill_map_coords_array():
	map_coords_array = []
	for x in range(map_width):
		for z in range(map_depth):
			map_coords_array.append(Coord.new(x, z))
			
func fill_random_map_coords():
	random_map_coords = map_coords_array.duplicate()
	random_map_coords.shuffle()
	
func get_next_random_map_coord():
	if not random_map_coords:
		fill_map_coords_array()
	return random_map_coords.pop_front()
	
func is_obstacle(coord: Coord):
	return obstacle_map[coord.x][coord.z]
	
func get_random_empty_coord():
	while true: # assume that there will always be at least one empty coord
		var coord = get_next_random_map_coord()
		if not is_obstacle(coord):
			return coord
			
func get_random_empty_vec3():
	return coord_to_vector3(get_random_empty_coord())
	
func coord_to_vector3(coord: Coord):
	var x = CELL_SIZE * coord.x - (map_width-1)*CELL_SIZE/2
	var z = CELL_SIZE * coord.z - (map_depth-1)*CELL_SIZE/2
	return Vector3(x, 0, z)
		
