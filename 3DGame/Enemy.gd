extends KinematicBody

class_name Enemy

onready var nav = $"../Navigation" as Navigation
onready var player = $"../Player" as KinematicBody

var path = []
var current_node = 0
var speed = 2

func _ready():
	pass  

func _physics_process(delta):
		
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		if direction.length() < 1:
			current_node += 1
		else:
			move_and_slide(direction.normalized() * speed)

func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)
	

func _on_Timer_timeout():
#	print("Looking for Player!")
	update_path(player.global_transform.origin)
	current_node = 0


func _on_Stats_you_died_signal():
	queue_free()
