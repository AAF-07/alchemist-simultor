extends TextureRect

@export var crop_data: CropData

func _ready() -> void:
	if crop_data:
		texture = crop_data.stages_textures[0]

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		SignalBus.item_clicked.emit(self)
