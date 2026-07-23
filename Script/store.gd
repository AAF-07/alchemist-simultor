extends Node2D




func _on_to_farm_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Farm.tscn")



func _on_to_lab_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Lab.tscn")
