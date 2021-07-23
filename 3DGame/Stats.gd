extends Node

class_name Stats

export var max_HP = 10 setget set_max_HP
onready var current_HP = max_HP

var dead = false

signal you_died_signal
signal update_health

func set_max_HP(new_max_HP):
	max_HP = new_max_HP
	current_HP = max_HP

func _ready():
	pass
	

func take_hit(damage):
	
	current_HP -= damage
	emit_signal("update_health", current_HP, max_HP)
	
	if current_HP <= 0 and not dead:
		die()
		
func die():
	dead = true
	emit_signal("you_died_signal")
