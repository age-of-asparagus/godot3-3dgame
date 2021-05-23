extends Spatial

export(PackedScene) var Enemy
onready var timer = $Timer
onready var navmap = $"../Navigation"

var enemies_remaining_to_spawn
var enemies_killed_this_wave

var waves # list of all the Wave nodes: [ Wave, Wave1, Wave2, ... ]
var current_wave: Wave # Wave node
var current_wave_number = -1

func _ready():
	waves = $Waves.get_children()
#	print("Waves: ", waves)
	start_next_wave()
	
func start_next_wave():
	enemies_killed_this_wave = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		enemies_remaining_to_spawn = current_wave.num_enemies
		timer.wait_time = current_wave.second_between_spawns
		timer.start()
	
func connect_to_enemy_signals(enemy: Enemy):
	var stats: Stats = enemy.get_node("Stats")
	stats.connect("you_died_signal", self, "_on_Enemy_Stats_you_died_signal")
	
func _on_Enemy_Stats_you_died_signal():
	enemies_killed_this_wave += 1
	print("Enemies killed: ", enemies_killed_this_wave)
	
func _on_Timer_timeout():
	if enemies_remaining_to_spawn:
		# SPAWN!
		var enemy = Enemy.instance()
		
		# Give the enemy a random position, that is NOT in an obstacle
		var location : Vector3 = navmap.get_random_empty_vec3()
		enemy.translate(Vector3(location.x, 0, location.z))
		
		connect_to_enemy_signals(enemy)
		var scene_root = get_parent()
		scene_root.add_child(enemy)
		enemies_remaining_to_spawn -= 1
	else:
		if enemies_killed_this_wave == current_wave.num_enemies:
			start_next_wave()
