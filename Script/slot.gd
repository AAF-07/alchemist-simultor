# slot.gd
class_name CraftingSlot
extends TextureRect

@export var slot_index: int
var item_data: ItemData = null

func clear_slot() -> void:
	item_data = null
	texture = null
