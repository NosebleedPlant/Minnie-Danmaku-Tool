extends Node2D

#_PRELOADS
#
var _Emitter = preload("res://Scenes/Emitter.tscn")		#emitter
var _Editor = preload("res://UI/Editor.tscn")			#the editor menu
var _Tab = preload("res://UI/Tab.tscn")					#tab in editor

#_GLOBALS:
#
var tab_emitter_map = {}
var emitter_count = 0
onready var editor = find_node("UI")
var repositioning_emitter = false						#indicates if repositioning
var rotating_emitter = false							#indicates if adjusting rotate
var emitter_editing:Node2D

#_MAIN: 
#
#handles user input
# warning-ignore:unused_argument
#param: delta(time between frames)
#return: enull
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

#notifies system that user is repositioning emitter or rotating emitter based on input
#param:viewport,event is the input event,shape_idx is the shape of colider
#return: null
# warning-ignore:unused_argument
# warning-ignore:unused_argument
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

#@TODO: adjust position and rotation with editor not directly
func update_XCoord(tab,x):
	tab_emitter_map[tab].position.x = x

func update_YCoord(tab,y):
	tab_emitter_map[tab].position.y = y

func update_Angle(tab,deg):
	tab_emitter_map[tab].set_rotation(deg2rad(deg))

func update_SprayCooldown(tab,value):
	tab_emitter_map[tab].spray_cooldown = value

func _on_SpreadEnabled(tab,button_pressed):
	if(tab_emitter_map[tab].spray_count <=1):
		tab.get_node("Menu/Spread_Input").pressed = false
		#@todo: pop-up warning
		return
	tab_emitter_map[tab].cone_spread_enabled = button_pressed

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
