extends Node2D

#_PRELOADS
#
var _Emitter = preload("res://addons/Scenes/Editable_Emitter.tscn")		#emitter
var _Editor = preload("res://addons/Scenes/UI/Editor.tscn")			#the editor menu
var _Tab = preload("res://addons/Scenes/UI/Tab.tscn")					#tab in editor

#_GLOBALS:
#
var tab_emitter_map = {}				#maps every tab to an emitter
var emitter_count = 0					#count of created emitters
onready var editor = find_node("UI")	#easy access to editor ui node
var repositioning_emitter = false		#indicates if repositioning
var rotating_emitter = false			#indicates if adjusting rotate
var emitter_editing:Node2D

#_MAIN: 
#
# handles user input
# warning-ignore:unused_argument
# param: delta(time between frames)
# return: enull
func _process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		var emitter = spawn_Emitter()#create new emitter at location of right click
		var tab = spawn_Editior(emitter)#create tabs in editor for each new emitter spawned
	if repositioning_emitter: reposition_Emitter(delta)
	if rotating_emitter: rotate_Emitter()
	return


#_HELPER FUNCTIONS:
#
#spawns the emitter
#param: null
#return: emitter
func spawn_Emitter():
	var emitter = _Emitter.instance()
	emitter_count+=1
	emitter.init(get_global_mouse_position(),"Default_Emitter_"+str(emitter_count))
	self.add_child(emitter)#emitter enters tree
	return emitter

#makes editor visable and spawns a tab that is responsible for this emitter, triggers on middle mouse
#param: the emitter this tab is responsible for
#return: tab
func spawn_Editior(emitter):
	var tab
	if(emitter_count<=1):#first emitter create both editor and tab
		editor.get_node("Editor").set_visible(true)
	tab = _Tab.instance()
	editor.get_node("Editor").add_child(tab)
	tab.init(emitter)
	tab_emitter_map[tab] = emitter#adds emitter and tab pair to map
	return tab

#handles user input for adjusting an emitter directly
#param:emitter that is being adjusted, the input event
#return: null
func adjustment_Input(emitter,event):
	if event.is_action_pressed("mouse_right"):
		repositioning_emitter = true
		emitter_editing = emitter
	if event.is_action_pressed("mouse_right") and Input.is_action_pressed("rotate"):
		repositioning_emitter = false
		rotating_emitter = true
		emitter_editing = emitter

#drag and reposition emitter by lerping to mouse positon at rate of 25*delta, triggers on right click
#param:delta(time between frames)
#return: null
func reposition_Emitter(delta):
	emitter_editing.position = lerp(emitter_editing.position,get_global_mouse_position(),25*delta)
	if Input.is_action_just_released("mouse_right"):
		repositioning_emitter = false

#adjust rotation of emitter to look at mouse location, triggers on ctrl+right click
#param:delta(time between frames)
#return: null
func rotate_Emitter():
	emitter_editing.look_at(get_global_mouse_position())
	if Input.is_action_just_released("rotate"):
		rotating_emitter = false

#_UPDATE VIEW:
#
#checks to see if the associated emitter of a tab has been changed directly and 
#reflects the changes to tab if it has
#param: tab
#return: null
func update_Tab(tab):
	var emitter_position = tab_emitter_map[tab].position
	if(repositioning_emitter):
		print("edited")
		tab.set_position_field(emitter_position)

	var emitter_rotation = tab_emitter_map[tab].rotation
	if(rotating_emitter):
		tab.set_rotation_field(emitter_rotation)
	return

#_UPDATE MODEL:
#
#function to update the x cooridnate of emitter
#params: tab that was updated and new value
#return: null
func update_XCoord(tab,x):
	tab_emitter_map[tab].position.x = x

#function to update the y cooridnate of emitter
#params: tab that was updated and new value
#return: null
func update_YCoord(tab,y):
	tab_emitter_map[tab].position.y = y

#function to update the angle of emitter
#params: tab that was updated and new value
#return: null
func update_Angle(tab,deg):
	tab_emitter_map[tab].set_rotation(deg2rad(deg))

#function to update the spray cooldown of emitter
#params: tab that was updated and new value
#return: null
func update_SprayCooldown(tab,value):
	tab_emitter_map[tab].spray_cooldown = value

#function to update the spread status of emitter
#params: tab that was updated and new value
#return: null
func update_SpreadEnabled(tab,button_pressed):
	if(tab_emitter_map[tab].spray_count <=1):
		tab.get_node("Menu/Spread_Input").pressed = false
		#@todo: pop-up warning
		return
	tab_emitter_map[tab].cone_spread_enabled = button_pressed

#function to update the spray count of emitter
#params: tab that was updated and new value
#return: null
func update_SprayCount(tab,value):
	if(tab_emitter_map[tab].cone_spread_enabled==true and value<=1):
		get_node("Menu/SprayCount_Input").get_line_edit().text = str(tab_emitter_map[tab].spray_count)
		get_node("Menu/Spread_Input").pressed = false
		#@todo: pop-up warning
		return
	tab_emitter_map[tab].spray_count = value

#function to update the spray cone angle of emitter
#params: tab that was updated and new value
#return: null
func update_ConeAngle(tab,value):
	tab_emitter_map[tab].cone_angle = deg2rad(value)

#function to update the spread width value of emitter
#params: tab that was updated and new value
#return: null
func update_SpreadWidth(tab,value):
	tab_emitter_map[tab].spread_width = value

#function to update the rotation rate of emitter
#params: tab that was updated and new value
#return: null
func update_RotationRate(tab,value):
	tab_emitter_map[tab].rotation_rate = value

#function to update the aim status of emitter
#params: tab that was updated and new value
#return: null
func update_AimEnabled(tab,button_pressed):
	tab_emitter_map[tab].aim_enabled = button_pressed

#function to update the aim cooldon value of emitter
#params: tab that was updated and new value
#return: null
func update_AimCooldown(tab,value):
	tab_emitter_map[tab].aim_pause = value

#function to update the x offset value of emitter
#params: tab that was updated and new value
#return: null
func update_XOff(tab,value):
	tab_emitter_map[tab].aim_offset.x = value

#function to update the y offset value of emitter
#params: tab that was updated and new value
#return: null
func update_YOff(tab,value):
	tab_emitter_map[tab].aim_offset.y = value

#function to update the load path of emitter
#params: tab that was updated and new value
#return: null
func update_loadSelected(tab,path):
	tab_emitter_map[tab].load_Emitter(path)

#function to update the save path of emitter
#params: tab that was updated and new value
#return: null
func update_savePathSelected(tab,path):
	tab_emitter_map[tab].save(path)
