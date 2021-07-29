extends Spatial

export(Array, PackedScene) var levels

var ray_origin = Vector3()
var ray_target = Vector3()

onready var player = $Player
onready var hand = $Player/Body/Hand

var navmap: NavigationMap
export var current_level = 0

func _ready():
	add_navmap()
	$HUD.update_level(current_level)
	$Spawner.start_next_wave()
	# To force an update of the HUD
	player.get_node("Stats").take_hit(0)

func _physics_process(delta):
	# "[Deleted Object]"
	if is_instance_valid(player):
		var mouse_position = get_viewport().get_mouse_position()
	#	print("Mouse Position: ", mouse_position)
		
		ray_origin = $Camera.project_ray_origin(mouse_position)
	#	print("ray_origin: ", ray_origin)
		ray_target = ray_origin + $Camera.project_ray_normal(mouse_position) *2000
		
		var space_state = get_world().direct_space_state
		var intersection = space_state.intersect_ray(ray_origin, ray_target, [], 8)
		
		if not intersection.empty():
	#		print("NOT EMPTY!")
			var pos = intersection.position
			var look_at_me = Vector3(pos.x, player.translation.y ,pos.z)
			player.look_at(look_at_me, Vector3.UP )
			var distance_to_pointer = hand.global_transform.origin - look_at_me
			if distance_to_pointer.length() > 3:
				hand.look_at(look_at_me, Vector3.UP )
	
	
func add_navmap():
	navmap = levels[current_level].instance()
	add_child(navmap)
	$Spawner.set_navmap(navmap)
	
func new_level():
	current_level += 1
	if current_level < levels.size():
		$HUD.update_level(current_level)
		navmap.queue_free()
		add_navmap()
		
		# Move the player back to the middle
		player.reset_position()
		# Reset the spawner
		$Dropper.reset()
		$Spawner.reset()
	else:
		print("You win!")

func _on_Spawner_level_complete():
	new_level()
