extends Sprite

#_MAIN:
func _process(delta):
	#simple behaviour to move player to mouse position for testing
	self.position = get_global_mouse_position()
	return
