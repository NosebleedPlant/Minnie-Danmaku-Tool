extends Tabs

#_GLOBALS:
#
onready var controler = get_tree().get_root().get_child(0)

#_MAIN:
#
# warning-ignore:unused_argument
func _process(delta):
	controler.update_Tab(self)
	return

#INITALIZATION METHOD:
#
#initalizes the emitter before it enters scnee
func init(emitter):
	self.name = str(emitter.name)#set name
	set_name_field(emitter.name)#set name feild

#_SIGNAL EVENTS:
#
#call when x coordinate has been set
func _on_set_X(value):
	controler.update_XCoord(self,value)

#call when y coordinate has been set
func _on_set_Y(value):
	controler.update_YCoord(self,value)

#call when angle has been set
func _on_set_Angle(value):
	controler.update_Angle(self,value)

#call when spray cooldown
func _on_set_SprayCooldown(value):
	controler.update_SprayCooldown(self,value)

#call when spread is enabled
func _on_SpreadEnabled(value):
	controler.update_SpreadEnabled(self,value)

#call when spray count has been set
func _on_set_SprayCount(value):
	controler.update_SprayCount(self,value)

#call when cone angle has been set
func _on_set_ConeAngle(value):
	controler.update_ConeAngle(self,value)

#call when spread width has been set
func _on_set_SpreadWidth(value):
	controler.update_SpreadWidth(self,value)

#call when rotation rate has been set
func _on_set_RotationRate(value):
	controler.update_RotationRate(self,value)

#call when aim is enabled
func _on_set_AimEnabled(value):
	controler.update_AimEnabled(self,value)

#call when aim cooldown is set
func _on_set_AimCooldown(value):
	controler.update_AimCooldown(self,value)

#call when xoffset is set
func _on_set_XOff(value):
	controler.update_XOff(self,value)

#call when yoffset is 
func _on_set_YOff(value):
	controler.update_YOff(self,value)

#call when emitter load button pressed, pops the load warning
func _on_Load_emitter():
	get_node("LoadWarning").popup_centered()

#call when load warning is accepted
func _on_acceptLoadWarning():
	get_node("LoadDialog").popup_centered()

#call when load directory selected
func _on_loadSelected(path):
	controler.update_loadSelected(self,path)

#call when emitter save button pressed
func _on_SaveEmitter():
	get_node("SaveDialog").popup_centered()

#call when save directory selected
func _on_savePathSelected(path):
	controler.update_savePathSelected(self,path)


#_SETTERS:
func set_name_field(name_text):
	get_node("Menu/Name_Input").text = name_text

func set_position_field(position):
	get_node("Menu/HBoxContainer3/X_Input").get_line_edit().text = str(position.x)
	get_node("Menu/HBoxContainer4/Y_Input").get_line_edit().text = str(position.y)

func set_rotation_field(angle):
	get_node("Menu/Rotation_Input").get_line_edit().text = str(rad2deg(angle))

func set_SprayCooldown(value):
	get_node("Menu/SprayCooldown_Input").get_line_edit().text = str(value)

func set_SpreadEnabled(value):
	get_node("Menu/Spread_Input").pressed = value

func set_SprayCount(value):
	get_node("Menu/SprayCount_Input").get_line_edit().text = str(value)

func set_ConeAngle(value):
	get_node("Menu/ConeAngle_Input").get_line_edit().text = str(value)

func set_SpreadWidth(value):
	get_node("Menu/SpreadWidth_Input").get_line_edit().text = str(value)

func set_RotationRate(value):
	get_node("Menu/Rotation_Rate_Input").get_line_edit().text = str(value)

func set_AimEnabled(value):
	get_node("Menu/Aim_Input").pressed = value

func set_AimCooldown(value):
	get_node("Menu/Aim_Cooldown_Input").get_line_edit().text = str(value)

func set_aimOffset(value):
	get_node("Menu/HBoxContainer/Xoffset_Input").get_line_edit().text = str(value.x)
	get_node("Menu/HBoxContainer2/Yoffset_Input").get_line_edit().text = str(value.y)

#_GETTERS:
func get_position_field():
	return Vector2(
		float(get_node("Menu/HBoxContainer3/X_Input").get_line_edit().text),
		float(get_node("Menu/HBoxContainer4/Y_Input").get_line_edit().text)
		)

func get_rotation_field():
	return deg2rad(float(get_node("Menu/Rotation_Input").get_line_edit().text))
