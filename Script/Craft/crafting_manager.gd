# crafting_manager.gd
extends Control

@export var custom_cursor: TextureRect
@export var slots: Array[CraftingSlot] = []
@export var recipe_results: Array[ItemData] = []
@export var recipes: Array[String] = [] # Comma-separated strings, e.g., "Herb,Herb,null,"
@export var result_slot: TextureRect

var current_item_data: ItemData = null
var item_list: Array[ItemData] = []

func _ready() -> void:
	SignalBus.item_clicked.connect(_on_item_clicked)
	custom_cursor.hide()
	result_slot.hide()
	
	# Initialize the item tracking list to match slot count
	item_list.resize(slots.size())

func _process(_delta: float) -> void:
	# If holding an item, update custom cursor position
	if current_item_data and custom_cursor.visible:
		custom_cursor.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	# Equivalent to Mouse.current.leftButton.wasReleasedThisFrame
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if current_item_data != null:
			_handle_item_placement()

func _on_item_clicked(item_node: Control) -> void:
	if current_item_data == null:
		current_item_data = item_node.item_data
		custom_cursor.texture = current_item_data.texture
		custom_cursor.show()
		print("Current item set to: ", current_item_data.item_name)
	else:
		print("Current item already set to: ", current_item_data.item_name)

func _handle_item_placement() -> void:
	if slots.is_empty():
		current_item_data = null
		return

	var mouse_pos = get_global_mouse_position()
	var nearest_slot: CraftingSlot = null
	var nearest_distance: float = INF

	# Find closest slot
	for slot in slots:
		if slot == null: continue
		# Get center position of the slot
		var slot_center = slot.global_position + (slot.size / 2)
		var distance = mouse_pos.distance_to(slot_center)
		
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_slot = slot

	# 50-pixel buffer zone so it doesn't snap if dropped far away
	if nearest_slot != null and nearest_distance < 50.0:
		nearest_slot.show()
		nearest_slot.texture = current_item_data.texture
		nearest_slot.item_data = current_item_data
		item_list[nearest_slot.slot_index] = current_item_data

	# Reset tracking state safely
	current_item_data = null
	custom_cursor.hide()
	_check_recipe()

func _check_recipe() -> void:
	result_slot.hide()
	
	# Build recipe string matching your logic
	var current_recipe_string = ""
	for item in item_list:
		if item != null:
			current_recipe_string += item.item_name + ","
		else:
			current_recipe_string += "null,"

	# Validate against recipe database
	for i in range(recipes.size()):
		if current_recipe_string == recipes[i]:
			result_slot.show()
			result_slot.texture = recipe_results[i].texture
			break

# Call this from your Slot UI layout via an event or button click
func on_click_slot(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < slots.size():
		var target_slot = slots[slot_index]
		if target_slot != null:
			target_slot.clear_slot()

	if slot_index >= 0 and slot_index < item_list.size():
		item_list[slot_index] = null

	_check_recipe()
