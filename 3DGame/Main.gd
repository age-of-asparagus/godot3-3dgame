extends Spatial

var ray_origin = Vector3()
var ray_target = Vector3()

onready var player = $Player

func _physics_process(delta):
	# "[Deleted Object]"
	if is_instance_valid(player):
		var mouse_position = get_viewport().get_mouse_position()
	#	print("Mouse Position: ", mouse_position)
		
		ray_origin = $Camera.project_ray_origin(mouse_position)
	#	print("ray_origin: ", ray_origin)
		ray_target = ray_origin + $Camera.project_ray_normal(mouse_position) *2000
		
		var space_state = get_world().direct_space_state
		var intersection = space_state.intersect_ray(ray_origin, ray_target)
		
		if not intersection.empty():
	#		print("NOT EMPTY!")
			var pos = intersection.position
			var look_at_me = Vector3(pos.x, player.translation.y ,pos.z)
			player.look_at(look_at_me, Vector3.UP )
	
