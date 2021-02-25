extends Node

class_name Stats

export var max_HP = 10
var current_HP = max_HP

signal you_died_signal

func _ready():
	pass
	

func take_hit(damage):
	
	current_HP -= 1
	print("I'm hit!! ", current_HP,  "/", max_HP)
	
	if current_HP <= 0:
		die()
		
func die():
	emit_signal("you_died_signal")
