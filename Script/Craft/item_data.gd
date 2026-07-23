# item_data.gd
class_name ItemData
extends Resource

enum ProcessState{RAW, GROUND, BOILED, ROASTED}

@export var item_name:String
@export var texture:Texture2D
#@export var current_state:ProcessState = ProcessState.RAW
#
#func get_state_name() -> String:
	#match current_state:
		#ProcessState.GROUND: return "GROUND_" + item_name
		#ProcessState.BOILED: return "BOILED_" + item_name
		#ProcessState.ROASTED: return "ROASTED_" + item_name
		#_: return item_name 
