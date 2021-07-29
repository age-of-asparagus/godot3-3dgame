extends Node

export(PackedScene) var StartingWeapon
var hand : Position3D
var equipped_weapon : Gun

signal ammo_update

func _ready():
	hand = get_parent().find_node("Hand")
	
	if StartingWeapon:
		equip_weapon(StartingWeapon)

func equip_weapon(weapon_to_equip: PackedScene):
	if equipped_weapon:
		print("Deleting current weapon")
		equipped_weapon.queue_free()

	print("No weapon equipped")
	equipped_weapon = weapon_to_equip.instance()
	hand.add_child(equipped_weapon)
	equipped_weapon.connect("update_ammo", self, "on_Gun_ammo_update")
	equipped_weapon.reload()
		
func hold_trigger():
	if equipped_weapon:
		equipped_weapon.hold_trigger()
	
func release_trigger():
	if equipped_weapon:
		equipped_weapon.release_trigger()

func reload():
	if equipped_weapon:
		equipped_weapon.reload()
		
# SGINALS
func on_Gun_ammo_update(ammo_value):
	emit_signal("ammo_update", ammo_value)
