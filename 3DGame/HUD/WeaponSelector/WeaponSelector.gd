extends ItemList

export(Array, PackedScene) var weapon_inventory

signal weapon_selected

func _ready():
	for WeaponScene in weapon_inventory:
		add_weapon(WeaponScene)
		
	self.select(0)

func _input(event):
	if event.is_action_pressed("secondary_action"):
		var new_index = self.get_selected_items()[0] + 1
		if new_index >= self.get_item_count():
			new_index = 0
			
		self.select(new_index)
		self._on_WeaponSelector_item_selected(new_index)
		
	if event is InputEventKey and event.pressed:
		
		var new_index = null
		match event.scancode:
			KEY_1:
				new_index = 0
			KEY_2:
				new_index = 1
			KEY_3:
				new_index = 2
			KEY_4:
				new_index = 3
			KEY_5:
				new_index = 4
			KEY_6:
				new_index = 5
				
		if new_index != null and new_index < self.get_item_count():
			self.select(new_index)
			_on_WeaponSelector_item_selected(new_index)		

func add_weapon(WeaponScene: PackedScene):
	var weapon: Gun = WeaponScene.instance()
	var text = str(self.get_item_count()+1) + ": " + weapon.gun_name
	self.add_item(text, weapon.icon)
	self.select(self.get_item_count() - 1)
	if not WeaponScene in weapon_inventory:
		weapon_inventory.append(WeaponScene)

func is_duplicate(NewWeaponScene: PackedScene):
	var new_weapon = NewWeaponScene.instance()
	
	var index = 0
	for WeaponScene in weapon_inventory:
		var weapon = WeaponScene.instance()
		if weapon.gun_name == new_weapon.gun_name:
			self.select(index)
			return true
		
		index += 1
			
	return false

func _on_WeaponSelector_item_selected(index):
	# Equip weapon
	var WeaponScene = weapon_inventory[index]
	emit_signal("weapon_selected", WeaponScene)

func _on_Dropper_item_picked_up(ItemScene: PackedScene):
	if not is_duplicate(ItemScene):
		add_weapon(ItemScene)
