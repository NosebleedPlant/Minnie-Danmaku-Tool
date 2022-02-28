extends Tabs

var id = 0
#_GLOBALS:
onready var controler = get_tree().get_root().get_child(0)

#INITALIZATION METHOD:
#
#initalizes the emitter before it enters scnee
func init(idx,emitter_name,position,fire_rate,volley_size,array_count,bullet_speed,bullet_lifespan):
	self.name = str(idx)#set name
	set_Name_field(emitter_name)#set name feild
	set_Position_field(position)#set position field with starting position
	set_FireRate_field(fire_rate)#set fire rate field with starting fire rate
	set_VolleySize_field(volley_size)#set volley size field with starting volley size
	set_ArrayCount_field(array_count)#set array count with starting array count
	set_BulletSpeed_field(bullet_speed)#set bullet speed field with starting value
	set_BulletLifespan_field(bullet_lifespan)#set bullet lifespan field with starting value
#_FIELD UPDATE SIGNAL EVENTS:
#
func on_set_Name(value):
	controler.update_Name(self,value)
#_-position params
func on_set_X(value):
	controler.update_PositionY(self,value)
func on_set_Y(value):
	controler.update_PositionX(self,value)
func on_set_Angle(value):
	controler.update_Angle(self,value)
#_-firing params
func on_set_FireRate(value):
	controler.update_FireRate(self,value)
func on_set_ClipSize(value):
	controler.update_ClipSize(self,value)
func on_set_ReloadTime(value):
	controler.update_ReloadTime(self,value)
#_-rotation params
func on_set_AngularVelocity(value):
	controler.update_AngularVelocity(self,value)
func on_set_AngularAcceleration(value):
	controler.update_AngularAcceleration(self,value)
func on_set_MaxAngularVelocity(value):
	controler.update_MaxAngularVelocity(self,value)
#_-spread params
func on_set_VolleySize(value):
	controler.update_VolleySize(self,value)
func on_set_SpreadAngle(value):
	controler.update_SpreadAngle(self,value)
func on_set_SpreadWidth(value):
	controler.update_SpreadWidth(self,value)
#_-array params
func on_set_ArrayCount(value):
	controler.update_ArrayCount(self,value)
func on_set_ArrayAngle(value):
	controler.update_ArrayAngle(self,value)
#_-aim params
func on_set_AimEnabled(value):
	controler.update_AimEnabled(self,value)
func on_set_AimPause(value):
	controler.update_AimPause(self,value)
func on_set_AimOffset(value):
	controler.update_AimOffset(self,value)
#_-bullet params
func on_set_BulletSpeed(value):
	controler.update_BulletSpeed(self,value)
func on_set_BulletLifespan(value):
	controler.update_BulletLifespan(self,value)

#_BUTTON PRESS EVENTS:
#call when emitter load button pressed, pops the load warning
func on_LoadEmitter():
	get_node("LoadWarning").popup_centered()

#call when load warning is accepted, pops up the file system
func on_acceptLoadWarning():
	get_node("LoadDialog").popup_centered()

#call when load directory selected in file system
func on_loadSelected(path):
	controler.load_Selected(self,path)

#call when emitter load button pressed, pops the load warning
func on_LoadBullet():
	get_node("LoadBulletDialog").popup_centered()

#call when load directory selected in file system
func on_bulletSelected(path):
	controler.update_Bullet(self,path)

#call when emitter save button pressed, pops up file system
func on_SaveEmitter():
	get_node("SaveDialog").popup_centered()

#call when save directory selected in file system
func on_savePathSelected(path):
	controler.save_File(self,path)

#call when emitter delete button pressed, pops the delete warning
func on_Delete():
	get_node("DeleteWarning").popup_centered()

#deletes emitter
func on_acceptDeleteWarning():
	controler.delete_Emitter(self)

#_UPDATE FIELDS:
#
#_-name
func set_Name_field(value):
	get_node("Menu/Name_Input").text = value
#_-position params
func set_Position_field(position):
	print(position)
	get_node("Menu/HBoxContainer3/X_Input").get_line_edit().text = str(position.x)
	get_node("Menu/HBoxContainer4/Y_Input").get_line_edit().text = str(position.y)
	get_node("Menu/HBoxContainer3/X_Input").apply()
	get_node("Menu/HBoxContainer4/Y_Input").apply()
func set_Angle_field(value):
	get_node("Menu/Angle_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/Angle_Input").apply()
#_-firing params
func set_FireRate_field(value):
	get_node("Menu/FireRate_Input").get_line_edit().text = str(value)
	get_node("Menu/FireRate_Input").apply()
func set_ClipSize_field(value):
	get_node("Menu/ClipSize_Input").get_line_edit().text = str(value)
	get_node("Menu/ClipSize_Input").apply()
func set_ReloadTime_field(value):
	get_node("Menu/ReloadTime_Input").get_line_edit().text = str(value)
	get_node("Menu/ReloadTime_Input").apply()
#_-rotation params
func set_AngularVelocity_field(value):
	get_node("Menu/AngularVelocity_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/AngularVelocity_Input").apply()
func set_AngularAcceleration_field(value):
	get_node("Menu/AngularAcceleration_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/AngularAcceleration_Input").apply()
func set_MaxAngularVelocity_field(value):
	get_node("Menu/MaxAngularVelocity_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/MaxAngularVelocity_Input").apply()
	#_-spread params
func set_VolleySize_field(value):
	get_node("Menu/VolleySize_Input").get_line_edit().text = str(value)
	get_node("Menu/VolleySize_Input").apply()
func set_SpreadAngle_field(value):
	get_node("Menu/SpreadAngle_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/SpreadAngle_Input").apply()
func set_SpreadWidth_field(value):
	get_node("Menu/SpreadWidth_Input").get_line_edit().text = str(value)
	get_node("Menu/SpreadWidth_Input").apply()
#_-array params
func set_ArrayCount_field(value):
	get_node("Menu/ArrayCount_Input").get_line_edit().text = str(value)
	get_node("Menu/ArrayCount_Input").apply()
func set_ArrayAngle_field(value):
	get_node("Menu/ArrayAngle_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/ArrayAngle_Input").apply()
#_-aim params
func set_AimEnabled_field(value):
	get_node("Menu/AimEnabled_Input").pressed = value
func set_AimPause_field(value):
	get_node("Menu/AimPause_Input").get_line_edit().text = str(value)
	get_node("Menu/AimPause_Input").apply()
func set_AimOffset_field(value):
	get_node("Menu/AimOffset_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/AimOffset_Input").apply()
#_-bullet params
func set_BulletSpeed_field(value):
	get_node("Menu/BulletSpeed_Input").get_line_edit().text = str(value)
	get_node("Menu/BulletSpeed_Input").apply()
func set_BulletLifespan_field(value):
	get_node("Menu/BulletLifespan_Input").get_line_edit().text = str(rad2deg(value))
	get_node("Menu/BulletLifespan_Input").apply()
