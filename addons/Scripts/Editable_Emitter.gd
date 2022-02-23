extends "res://addons/Scripts/Abstract_Emitter.gd"

###############################################################################
#_EXTENSIONS:
###############################################################################
#_EXTRA VARIABLES:
var tab_idx = 0
var screen_size = OS.get_screen_size()

#_HELPER FUNCTIONS:
#
#initalization function sets starting vals
#param:spawn position, name of eitter
#return: null
func init(pos,name_str):
	self.position = pos
	self.name = name_str

#save the params for emitter
#param:save file name
#return: null
func save(file_path):
	print("called")
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_var(position)
	file.store_var(rotation)
	file.store_var(bullet_adress)
	file.store_var(burst_cooldown)
	file.store_var(rotation_rate)
	file.store_var(spread_enabled)
	file.store_var(burst_count)
	file.store_var(cone_angle)
	file.store_var(spread_width)
	file.store_var(aim_enabled)
	file.store_var(aim_pause)
	file.store_var(aim_offset)
	file.store_var(array_count)
	file.store_var(array_angle)
	file.close()
	return

#_SIGNAL EVENT:
#
#on input it calls the input handler from root
#param: input event
#return null
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_Input_Event(viewport, event, shape_idx):
	controler.adjustment_Input(self,event)
	return

###############################################################################
#_OVERRIDES:
###############################################################################
#chcks if out of bound and warps
#param: input event
#return null
func _bound_Handler():
	position.x = wrapf(position.x, -1, screen_size.x+1)
	position.y = wrapf(position.y, -1, screen_size.y+1)

