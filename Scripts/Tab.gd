extends Tabs
#_GLOBALS:
var connectedEmitter
var player_pos

#_MAIN:
# warning-ignore:unused_argument
func _process(delta):
	if(player_pos!=connectedEmitter.position):
		set_position_field(connectedEmitter.position)

#_SETTER GETTERS:
#sets the emitter that this tab is responsible for
#param:emitter
#return: null
func set_emitter(emitter):
	connectedEmitter = emitter

#sets the feilds for x,y
#param:position vector of player
#return: null
func set_position_field(position):
	get_node("Menu/X_Input").get_line_edit().text = str(position.x)
	get_node("Menu/Y_Input").get_line_edit().text = str(position.y)
	player_pos = position

#_SYSTEM OVERRIEDS:
func _on_set_Xoff(value):
	connectedEmitter.position.x = value
func _on_set_Yoff(value):
	connectedEmitter.position.y = value
