extends KinematicBody

onready var gun_controller = $GunController

var speed = 0
var max_speed = 8
var velocity := Vector3()
var move_direction := Vector3()
const GRAVITY = 5
const ACCEL = 1
var falling_speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Movement
	move_direction = Vector3()
	
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		move_direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		move_direction.z += 1
		
	if not move_direction:
		velocity = velocity.move_toward(Vector3(), ACCEL)
	else:
		velocity = velocity.move_toward(move_direction.normalized() * max_speed, ACCEL)
	
	falling_speed -= GRAVITY
	var result = move_and_slide(Vector3(velocity.x, falling_speed, velocity.z))
	falling_speed = result.y
	
	
	# Shoot shoot
	if Input.is_action_pressed("primary_action"):
		gun_controller.hold_trigger()
	else:
		gun_controller.release_trigger()
		
	# relaod
	if Input.is_action_just_pressed("reload"):
		gun_controller.reload()

func reset_position():
	global_transform.origin = Vector3(0, 3, 0)

func _on_Stats_you_died_signal():
	print("GAME OVER")
	queue_free()

func _on_Void_body_entered(body):
	print("AHHHHHHHHH!!!!!!!")
	queue_free()

func _on_Dropper_item_picked_up(ItemScene: PackedScene):
	var item = ItemScene.instance()
	
	# Hanfle different kinds of pickups:
	if item is Gun:
		gun_controller.equip_weapon(ItemScene)
