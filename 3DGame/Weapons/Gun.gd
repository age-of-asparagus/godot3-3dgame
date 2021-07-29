extends Spatial
class_name Gun

enum FireMode {
	SINGLE,
	BURST,
	AUTO,
}

export var gun_name = "Gun"
export(PackedScene) var Bullet
export(Array, PackedScene) var BulletSpawns
export var muzzle_speed = 30
export var millis_between_shots = 100
export(FireMode) var fire_mode = FireMode.AUTO
export var burst_shots = 3
export var mag_capacity = 13

var bullets_in_mag
var trigger_released = true
var can_shoot = true
var burst_shots_remaining
var bullet_spawns = []

onready var rof_timer = $Timer

signal update_ammo

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0
	reset_bursts()
#	reload()
	init_bullet_spawns()
	
func init_bullet_spawns():
	for Spawn in BulletSpawns:
		var spawn = Spawn.instance()
		$Mesh/Muzzle.add_child(spawn)
	bullet_spawns = $Mesh/Muzzle.get_children()
	
func reset_bursts():
	burst_shots_remaining = burst_shots
	
func reload():
	# Animate relaoding
	$AnimationPlayer.play("Reload")

func refill_mag():
	bullets_in_mag = mag_capacity
	emit_signal("update_ammo", bullets_in_mag)
	
func hold_trigger():
	match fire_mode:
		FireMode.SINGLE:
			if trigger_released:
				shoot()
		FireMode.BURST:
			print(burst_shots_remaining)
			if burst_shots_remaining:
				if shoot():
					burst_shots_remaining -= 1
		FireMode.AUTO:
			shoot()
	
	trigger_released = false
	
func release_trigger():
	trigger_released = true
	reset_bursts()
	
func shoot():
	if can_shoot and bullets_in_mag:
		for spawn in bullet_spawns:
			var new_bullet = Bullet.instance()
			new_bullet.global_transform = spawn.global_transform
			new_bullet.speed = muzzle_speed
			var scene_root = get_tree().get_root().get_children()[0]
			scene_root.add_child(new_bullet)
#		print("pew!")
		can_shoot = false
		rof_timer.start()
		bullets_in_mag -= 1
		emit_signal("update_ammo", bullets_in_mag)
		$AnimationPlayer.play("Recoil")
		return true
	elif not bullets_in_mag:
		reload()
		
	return false

func drop():
#	print("Gun dropped")
	$Mesh.translation = Vector3.ZERO
	$AnimationPlayer.play("Drop")
	
func _on_Timer_timeout():
#	print("You can shoot again bra")
	can_shoot = true
