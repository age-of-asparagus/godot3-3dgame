extends Spatial

export var speed = 70

const KILL_TIME = 2
var timer = 0

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)
	
	timer += delta
	if timer >= KILL_TIME:
		queue_free()


func _on_Area_body_entered(body):
	print("I hit you! ", body)
	queue_free()
