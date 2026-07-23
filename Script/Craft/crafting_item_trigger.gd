# crafting_item_trigger.gd
extends TextureRect

@export var item_data: ItemData

func _ready() -> void:
	if item_data:
		texture = item_data.texture

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		SignalBus.item_clicked.emit(self)
