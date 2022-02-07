extends Tabs
#_GLOBALS:
var connectedEmitter	#emitter that thsi tab is responsible for
var player_pos			#player position entered last
var last_angle			#last entered rotaion

#_MAIN:
# warning-ignore:unused_argument
func _process(delta):
	if(player_pos!=connectedEmitter.position):
		set_position_field(connectedEmitter.position)
	if(last_angle!=connectedEmitter.get_rotation()):
		set_rotation_field(connectedEmitter.get_rotation())
		pass

#_SETTER GETTERS:
#sets the feilds for the name
#param:name of emitter
#return: null
func set_name_field(name_text):
	get_node("Menu/Name_Input").text = name_text

#sets the feilds for x,y
#param:position vector of player
#return: null
func set_position_field(position):
	get_node("Menu/HBoxContainer3/X_Input").get_line_edit().text = str(position.x)
	get_node("Menu/HBoxContainer4/Y_Input").get_line_edit().text = str(position.y)
	player_pos = position

#sets the feilds for rotation angle
#param:new angle
#return: null
func set_rotation_field(angle):
	get_node("Menu/Rotation_Input").get_line_edit().text = str(rad2deg(angle))
	last_angle = angle

#_SYSTEM OVERRIEDS:
func init(emitter):
	connectedEmitter = emitter#set emitter
	self.name = str(emitter.name)#set name
	set_name_field(emitter.name)#set name feild

func _on_set_X(value):
	connectedEmitter.position.x = value

func _on_set_Y(value):
	connectedEmitter.position.y = value

func _on_set_Angle(value):
	connectedEmitter.set_rotation(deg2rad(value))

func _on_set_SprayCooldown(value):
	connectedEmitter.spray_cooldown = value

func _on_SpreadEnabled(button_pressed):
	if(connectedEmitter.spray_count <=1):
		get_node("Menu/Spread_Input").pressed = false
		#@todo: pop-up warning
		return
	connectedEmitter.cone_spread_enabled = button_pressed

func _on_set_SprayCount(value):
	if(connectedEmitter.cone_spread_enabled==true and value<=1):
		get_node("Menu/SprayCount_Input").get_line_edit().text = str(connectedEmitter.spray_count)
		get_node("Menu/Spread_Input").pressed = false
		#@todo: pop-up warning
		return
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

func _on_Save_pressed():
	connectedEmitter.save()

func _on_Load_emitter():
	#load data into feilds here
	#load data into emitter
	pass
