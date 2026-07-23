extends Control

@export var custom_cursor: TextureRect
@export var slots: Array[CraftingSlot] = []

var current_item_data: CropData = null
var item_list: Array[CropData] = []


func _ready() -> void:
	SignalBus.item_clicked.connect(_on_item_clicked)
	custom_cursor.hide()
	
func _process(_delta: float) -> void:
	# If holding an item, update custom cursor position
	if current_item_data and custom_cursor.visible:
		custom_cursor.global_position = get_global_mouse_position()
		
func _input(event: InputEvent) -> void:
	# Equivalent to Mouse.current.leftButton.wasReleasedThisFrame
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if current_item_data != null:
			_handle_item_placement()
			
func _on_item_clicked(item_node: Control):
	if current_item_data == null:
		if "crop_data" in item_node and item_node.crop_data != null:
			current_item_data = item_node.crop_data
		else:
			print("crop data nill")
		
		var selected_texture: Texture2D = null
		if current_item_data.stages_textures.size() > 0:
			selected_texture = current_item_data.stages_textures[0]
			print("stages texture")
		elif current_item_data.texture != null:
			selected_texture = current_item_data.texture
			
		custom_cursor.texture = selected_texture
		custom_cursor.global_position = get_global_mouse_position() - (custom_cursor.size / 2.0)
		custom_cursor.show()
	
func _handle_item_placement() -> void:
	if slots.is_empty():
		_clear_cursor_state()
		return

	var mouse_pos = get_global_mouse_position()
	var nearest_slot: CraftingSlot = null
	var patch = $FarmPatch
	var nearest_distance: float = INF

	# Find closest slot
	for slot in slots:
		if slot == null: continue
		var slot_center = slot.global_position + (slot.size / 2.0)
		var distance = mouse_pos.distance_to(slot_center)
		
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_slot = slot

	# 50-pixel buffer zone
	if nearest_slot != null and nearest_distance < 50.0:
		nearest_slot.show()
		
		# Set texture on slot correctly
		if "stages_textures" in current_item_data and current_item_data.stages_textures.size() > 0:
			nearest_slot.texture = current_item_data.stages_textures[0]
		elif "texture" in current_item_data:
			nearest_slot.texture = current_item_data.texture
			
		nearest_slot.item_data = current_item_data
		
		# Safely store item in resized list
		if nearest_slot.slot_index >= 0 and nearest_slot.slot_index < item_list.size():
			item_list[nearest_slot.slot_index] = current_item_data
			
		if patch.has_method("plant_seed"):
			patch.current_crop = current_item_data # <--- Assign crop BEFORE planting!
			patch.plant_seed() # Now current_crop won't be null!
		else:
			print("nearest slot dosen't have plant seed")
	# Reset tracking state cleanly
	_clear_cursor_state()


func _clear_cursor_state() -> void:
	current_item_data = null
	if custom_cursor != null:
		custom_cursor.hide()
		custom_cursor.texture = null
