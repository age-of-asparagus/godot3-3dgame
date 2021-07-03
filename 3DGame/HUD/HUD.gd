extends Control

onready var level = $GridContainer/LevelValue
onready var wave = $GridContainer/WaveValue
onready var health = $GridContainer2/HealthValue
onready var ammo = $GridContainer2/AmmoValue

func _ready():
	pass

func update_level(current_level):
	level.text = String(current_level + 1)


func _on_Spawner_wave_update(current_wave):
	wave.text = String(current_wave + 1)


func _on_Stats_update_health(current_health, max_health):
	health.text = String(current_health)


func _on_GunController_ammo_update(ammo_value):
	ammo.text = String(ammo_value)
