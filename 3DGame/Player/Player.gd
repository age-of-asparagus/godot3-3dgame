extends KinematicBody

onready var gun_controller = $GunController

var speed = 8
var velocity = Vector3()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Movement
	velocity = Vector3()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.z += 1
		
	velocity = velocity.normalized() * speed
		
	move_and_slide(velocity)
	
	# Shoot shoot
	if Input.is_action_pressed("primary_action"):
		gun_controller.shoot()


func _on_Stats_you_died_signal():
	print("GAME OVER")
	queue_free()
