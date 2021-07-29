extends Spatial

var DropItem: PackedScene
var drop_item: Node

signal item_picked_up

func _ready():
	$PickUpArea/CollisionShape.disabled = true
	
func drop():
	reset()
	
	drop_item = DropItem.instance()
	
	if drop_item.has_method("drop"):
	
		var navmap: NavigationMap = get_parent().navmap
		var location = navmap.get_random_empty_vec3()
		self.global_transform.origin = Vector3(location.x, self.global_transform.origin.y, location.z)
		
		drop_item.drop()
		$PickUpArea/CollisionShape.disabled = false
		self.add_child(drop_item)
	
	else:
		print("Invalid drop item, does not implement `drop` method.")

func reset():
	if is_instance_valid(drop_item):
		drop_item.queue_free()

func _on_PickUpArea_body_entered(body):
	emit_signal("item_picked_up", DropItem)
	$PickUpArea/CollisionShape.disabled = true
	drop_item.queue_free()
	

func _on_Spawner_drop_item(DropItem: PackedScene):
	self.DropItem = DropItem
	drop()
