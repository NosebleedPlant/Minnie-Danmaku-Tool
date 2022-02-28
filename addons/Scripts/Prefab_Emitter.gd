extends "res://addons/Scripts/Abstract_Emitter.gd"

###############################################################################
#_EXTENSIONS:
###############################################################################
export (String, FILE) var emitter_data_file #file containg emitter data

#loads emitter data, except the position data when entering scene
#param:none
#return:none
func _ready():
	var old_position = position
	load_Emitter(emitter_data_file)
	position = old_position

###############################################################################
#_OVERRIDES:
###############################################################################
#no overrides atm, feel free to write ur own here
