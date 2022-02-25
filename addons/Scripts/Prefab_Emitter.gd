extends "res://addons/Scripts/Abstract_Emitter.gd"

###############################################################################
#_EXTENSIONS:
###############################################################################
export (String, FILE) var emitter_data_file #file containg emitter data

#loads emitter data when entering scene
#param:none
#return:none
func _ready():
	load_Emitter(emitter_data_file)

###############################################################################
#_OVERRIDES:
###############################################################################
#no overrides atm, feel free to write ur own here
