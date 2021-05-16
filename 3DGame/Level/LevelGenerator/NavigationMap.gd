extends Navigation

class_name NavigationMap

var map_coords_array := []
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

func _ready():
	pass
	
func update_map_center():
	map_center = Coord.new(map_width/2, map_depth/2)
	
func fill_map_coords_array():
	map_coords_array = []
	for x in range(map_width):
		for z in range(map_depth):
			map_coords_array.append(Coord.new(x, z))
