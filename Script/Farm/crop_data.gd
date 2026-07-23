class_name CropData
extends ItemData

@export var crop_name: String
@export var growth_time:float = 5.0
@export var stages_textures: Array[Texture2D] # Textures: [0] Seedling, [1] Sprout, [2] Fully Grown
@export var harvested_crop:Resource
