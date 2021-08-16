extends Button

export var scene_to_load: PackedScene

func _ready():
	pass
	

func _on_Button_button_up():
	if scene_to_load:
		get_tree().change_scene_to(scene_to_load)
	else:
		get_tree().quit()
