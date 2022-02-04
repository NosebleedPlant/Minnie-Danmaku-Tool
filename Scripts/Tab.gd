extends Tabs
#_GLOBALS:
var connectedEmitter	#emitter that thsi tab is responsible for
var player_pos			#player position entered last

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
	get_node("Menu/HBoxContainer3/X_Input").get_line_edit().text = str(position.x)
	get_node("Menu/HBoxContainer4/Y_Input").get_line_edit().text = str(position.y)
	player_pos = position

#_SYSTEM OVERRIEDS:
func _on_set_X(value):
	connectedEmitter.position.x = value

func _on_set_Y(value):
	connectedEmitter.position.y = value

func _on_set_SprayCooldown(value):
	connectedEmitter.spray_cooldown = value

func _on_SpreadEnabled(button_pressed):
	connectedEmitter.cone_spread_enabled = button_pressed

func _on_set_SprayCount(value):
	connectedEmitter.spray_count = value

func _on_set_ConeAngle(value):
	connectedEmitter.set_spread_angle(value)

func _on_set_SpreadWidth(value):
	connectedEmitter.spread_width = value

func _on_set_RotationRate(value):
	connectedEmitter.rotation_rate = value

func _on_set_AimEnabled(button_pressed):
	connectedEmitter.aim_enabled = button_pressed

func _on_set_AimCooldown(value):
	connectedEmitter.aim_pause = value

func _on_set_XOff(value):
	connectedEmitter.aim_offset.x = value

func _on_set_YOff(value):
	connectedEmitter.aim_offset.y = value
