extends "res://Scripts/Abstract_Emitter.gd"

###############################################################################
#_EXTENSIONS:
###############################################################################
export (String, FILE) var emitter_data_file

func _ready():
	load_Emitter(emitter_data_file)

###############################################################################
#_OVERRIDES:
###############################################################################
#no overrides atm, feel free to write ur own here
