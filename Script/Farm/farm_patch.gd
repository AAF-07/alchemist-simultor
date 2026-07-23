extends HBoxContainer

@export var current_crop: CropData

@onready var growth_timer: Timer = $GrowthTimer
@onready var tes_item: TextureRect = $"../Tes item"

var current_stage = 0
var is_harvest:bool = false

func plant_seed() -> void:
	if current_crop != null:
		print("seed planted")
		current_stage = 0 
		is_harvest = false
		tes_item.texture = current_crop.stages_textures[current_stage]
		growth_timer.wait_time = 3.0
		growth_timer.start()
	else:
		print("current crop null")


func _on_growth_timer_timeout() -> void:
	current_stage += 1
	if current_stage < current_crop.stages_textures.size():
		tes_item.texture = current_crop.stages_textures[current_stage]
		print("change")
	else:
		tes_item.texture = current_crop.harvested_crop
		is_harvest = true
		
		growth_timer.stop()
		 
		print("panen!")
