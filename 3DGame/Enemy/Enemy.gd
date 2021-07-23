extends KinematicBody

class_name Enemy

var navmap: NavigationMap setget set_navmap
onready var player = $"../Player" as KinematicBody

onready var attack_timer = $AttackTimer

var default_material = load("res://Enemy/EnemyDefaultMaterial.tres")
var attack_material = load("res://Enemy/EnemyAttackMaterial.tres")
var resting_material = load("res://Enemy/EnemyRestingMaterial.tres")

var path = []
var current_node = 0
var speed = 2
var attack_speed_multiplier = 5
var damage = 1

var attack_target: Vector3
var return_target: Vector3

enum state {
	SEEKING,
	ATTACKING,
	RETURNING,
	RESTING,
}

var current_state = state.SEEKING

func set_navmap(new_navmap):
	navmap = new_navmap
	
func set_characteristics(health, damage, move_speed):
	$Stats.max_HP = health
	self.damage = damage
	self.speed = move_speed

func _ready():
	$MeshInstance.set_surface_material(0, default_material)

func _physics_process(delta):
	if is_instance_valid(player):
		match current_state:
			state.SEEKING:	
				if current_node < path.size():
					var seeking_vector: Vector3 = path[current_node] - global_transform.origin
					move_and_slide(seeking_vector.normalized() * speed)
					seeking_vector = path[current_node] - global_transform.origin
					if seeking_vector.length() < 1:
						current_node += 1
						
					# Check if we're close to the player
					if $AttackRadius.overlaps_body(player):
						init_attack()
					
			state.ATTACKING:
				move_and_attack()
			state.RETURNING:
				move_and_attack()
			state.RESTING:
				pass
	#			print("Resting!")			
			
func move_and_attack():
	var attack_vector: Vector3 = attack_target - global_transform.origin
	var direction: Vector3 = attack_vector.normalized()
	var distance = attack_vector.length()
	
#	print("I'm this far away from my target: ", distance)
	move_and_slide(direction * speed * attack_speed_multiplier)
	
	if distance < 1:
		match current_state:
			state.ATTACKING:
				# Do damage to the player
				var player_stats: Stats = player.get_node("Stats")
				player_stats.take_hit(damage)
#				print("I hit you: ", player_stats.current_HP, "/", player_stats.max_HP)
				current_state = state.RETURNING
				attack_target = return_target
			state.RETURNING:
				current_state = state.RESTING
				$MeshInstance.set_surface_material(0, resting_material)
				collide_with_other_enemies(true)
				move_and_slide(Vector3.ZERO)
				attack_timer.start()
				
func collide_with_other_enemies(should_we_collide):
	set_collision_mask_bit(2, should_we_collide)
	set_collision_layer_bit(2, should_we_collide)
	
func update_path(target_position):
	path = navmap.get_simple_path(global_transform.origin, target_position)
	

func _on_Stats_you_died_signal():
	queue_free()

func init_attack():
	attack_target = player.global_transform.origin
	return_target = global_transform.origin
	current_state = state.ATTACKING
	$MeshInstance.set_surface_material(0, attack_material)
	collide_with_other_enemies(false)


func _on_PathUpdateTimer_timeout():
#	print("Looking for Player!")
	if is_instance_valid(player):
		update_path(player.global_transform.origin)
		current_node = 0


func _on_AttackTimer_timeout():
	current_state = state.SEEKING
	$MeshInstance.set_surface_material(0, default_material)
