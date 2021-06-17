extends Spatial
class_name Gun

export(PackedScene) var Bullet
export(Array, PackedScene) var BulletSpawns

onready var rof_timer = $Timer
var can_shoot = true

export var muzzle_speed = 30
export var millis_between_shots = 100

enum FireMode {
	SINGLE,
	BURST,
	AUTO,
}
export(FireMode) var fire_mode = FireMode.AUTO
var trigger_released = true

# Burst
export var burst_shots = 3
var burst_shots_remaining

var bullet_spawns = []

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0
	reset_bursts()
	init_bullet_spawns()
	
func init_bullet_spawns():
	for Spawn in BulletSpawns:
		var spawn = Spawn.instance()
		$Muzzle.add_child(spawn)
	bullet_spawns = $Muzzle.get_children()
	
func reset_bursts():
	burst_shots_remaining = burst_shots
	
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
	if can_shoot:
		for spawn in bullet_spawns:
			var new_bullet = Bullet.instance()
			new_bullet.global_transform = spawn.global_transform
			new_bullet.speed = muzzle_speed
			var scene_root = get_tree().get_root().get_children()[0]
			scene_root.add_child(new_bullet)
#		print("pew!")
		can_shoot = false
		rof_timer.start()
		return true
	else:
		return false


func _on_Timer_timeout():
#	print("You can shoot again bra")
	can_shoot = true
