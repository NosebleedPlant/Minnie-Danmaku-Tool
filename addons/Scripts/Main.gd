extends Node2D

#_PRELOADS
export var _Emitter = preload("res://addons/Scenes/Editable_Emitter.tscn")		#emitter
var _Tab = preload("res://addons/Scenes/UI/Tab.tscn")					#tab in editor

#_GLOBALS:
#
var emitter_count = 0										#count of created emitters
var emitter_editing:Node2D
var tab_count = 0
var tab_emitter_map = {}									#maps every tab to an emitter
var emitter_tab_map = {}									#maps every emitter to a tab
var repositioning_emitter = false							#indicates if repositioning
var rotating_emitter = false								#indicates if adjusting rotate
onready var player = find_node("Player")					#easy acess to player node
onready var main_tree = get_tree()							#easy acess to scene tree
onready var editor:TabContainer = find_node("UI").get_node("Editor")		#easy access to editor ui node
var screen_size = OS.get_screen_size()

#_INPUT BINDINGS:
var input_spawn = "mouse_left"
var input_adjust = "mouse_right"
var input_rotate = "rotate"

#_MAIN: 
#
# handles user input
# param: input event
# return: null
func _unhandled_input(event):
	if event.is_action_pressed(input_spawn):
		var emitter = spawn_Emitter()#create new emitter at location of right click
		var tab = spawn_Editior(emitter)#create tabs in editor for each new emitter spawned
	if event.is_action_released(input_adjust):
		repositioning_emitter = false
		rotating_emitter = false
	if event.is_action_released(input_rotate):
		rotating_emitter = false
	return

# calls adjustment functions when needed
# warning-ignore:unused_argument
# param: delta(time between frames)
# return: null
func _process(delta):
	if repositioning_emitter: reposition_Emitter(delta)
	if rotating_emitter: rotate_Emitter()
	main_tree.call_group("bullets","set_PlayerPosition",player.position)
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
	emitter_editing = emitter#sets current emitter to be the one that is being edited
	return emitter

#makes editor visable and spawns a tab that is responsible for this emitter, triggers on middle mouse
#param: the emitter this tab is responsible for
#return: tab
func spawn_Editior(emitter):
	var tab
	if(emitter_count<=1):#first emitter create both editor and tab
		editor.set_visible(true)
	tab = _Tab.instance()
	editor.add_child(tab)
	tab_emitter_map[tab] = emitter#adds emitter and tab pair to map
	emitter_tab_map[emitter] = tab#adds tab and emitter pair to map
	tab.init(tab_count,emitter.get_name(),emitter.get_position(),
			emitter.get_fire_rate(),emitter.get_volley_size(),emitter.get_array_count(),
			emitter.get_bullet_speed(),emitter.get_bullet_lifespan())
	editor.current_tab = tab_count#sets editor to the page of the new tab
	tab_count+=1
	return tab

#drag and reposition emitter by lerping to mouse positon at rate of 25*delta, triggers on right click
#param:delta(time between frames)
#return: null
func reposition_Emitter(delta):
	#calculates new position
	var new_position = lerp(emitter_editing.position,get_global_mouse_position(),25*delta)
	#clamps values so emitter dosnt go off screen
	new_position.x = clamp(new_position.x,0,screen_size.x)
	new_position.y = clamp(new_position.y,0,screen_size.y)
	emitter_editing.set_position(new_position)
	emitter_tab_map[emitter_editing].set_Position_field(emitter_editing.get_position())

#adjust rotation of emitter to look at mouse location, triggers on ctrl+right click
#param:delta(time between frames)
#return: null
func rotate_Emitter():
	emitter_editing.set_angle(get_global_mouse_position())
	emitter_tab_map[emitter_editing].set_Angle_field(emitter_editing.get_angle())

#handles user input for adjusting an emitter directly
#param:emitter that is being adjusted, the input event
#return: null
func adjustment_Input(emitter,event):
	if event.is_action_pressed(input_adjust):
		repositioning_emitter = true
		emitter_editing = emitter
		editor.current_tab = int(emitter_tab_map[emitter].name)
		if Input.is_action_pressed(input_rotate):
			repositioning_emitter = false
			rotating_emitter = true
	return

#_UPDATE MODEL:
#
func update_Name(tab,value):
	tab_emitter_map[tab].set_name(value)
#_-position params
func update_PositionX(tab,value):
	tab_emitter_map[tab].set_position_y(value)
func update_PositionY(tab,value):
	tab_emitter_map[tab].set_position_x(value)
func update_Angle(tab,value):
	tab_emitter_map[tab].set_angle(value)
#_-firing params
func update_FireRate(tab,value):
	tab_emitter_map[tab].set_fire_rate(value)
func update_ClipSize(tab,value):
	tab_emitter_map[tab].set_clip_size(value)
func update_ReloadTime(tab,value):
	tab_emitter_map[tab].set_reload_time(value)
#_-rotation params
func update_AngularVelocity(tab,value):
	tab_emitter_map[tab].set_angular_velocity(value)
func update_AngularAcceleration(tab,value):
	tab_emitter_map[tab].set_angular_acceleration(value)
func update_MaxAngularVelocity(tab,value):
	tab_emitter_map[tab].set_max_angular_velocity(value)
#_-spread params
func update_VolleySize(tab,value):
	tab_emitter_map[tab].set_volley_size(value)
func update_SpreadAngle(tab,value):
	tab_emitter_map[tab].set_spread_angle(value)
func update_SpreadWidth(tab,value):
	tab_emitter_map[tab].set_spread_width(value)
#_-array params
func update_ArrayCount(tab,value):
	tab_emitter_map[tab].set_array_count(value)
func update_ArrayAngle(tab,value):
	tab_emitter_map[tab].set_array_angle(value)
#_-aim params
func update_AimEnabled(tab,value):
	tab_emitter_map[tab].set_aim_enabled(value)
func update_AimPause(tab,value):
	tab_emitter_map[tab].set_aim_pause(value)
func update_AimOffset(tab,value):
	tab_emitter_map[tab].set_aim_offset(value)
#_-bullet params
func update_Bullet(tab,value):
	tab_emitter_map[tab].set_bullet(value)
func update_BulletSpeed(tab,value):
	tab_emitter_map[tab].set_bullet_speed(value)
func update_BulletLifespan(tab,value):
	tab_emitter_map[tab].set_bullet_lifespan(value)

#function to update the load path of emitter
#params: tab that was updated and new value
#return: null
func load_Selected(tab,path):
	var emitter = tab_emitter_map[tab]
	emitter.load_Emitter(path)
	tab.set_Name_field(emitter.get_name())
	
	#_-position params
	tab.set_Position_field(emitter.get_poistion())
	tab.set_Angle_field(emitter.get_angle())
	
	#_-firing param
	tab.set_FireRate_field(emitter.get_fire_rate())
	tab.set_ClipSize_field(emitter.get_clip_size())
	tab.set_ReloadTime_field(emitter.get_reload_time())
	
	#_-rotation params
	tab.set_AngularVelocity_field(emitter.get_angular_velocity())
	tab.set_AngularAcceleration_field(emitter.get_angular_acceleration())
	tab.set_MaxAngularVelocity_field(emitter.get_max_angular_velocity())
	
	#_-spread params
	tab.set_VolleySize_field(emitter.get_volley_size())
	tab.set_SpreadAngle_field(emitter.get_spread_angle())
	tab.set_SpreadWidth_field(emitter.get_spread_width())
	
	#_-array params
	tab.set_ArrayCount_field(emitter.get_array_count())
	tab.set_ArrayAngle_field(emitter.get_array_angle())
	
	#_-aim params
	tab.set_AimEnabled_field(emitter.get_aim_enabled())
	tab.set_AimPause_field(emitter.get_aim_pause())
	tab.set_AimOffset_field(emitter.get_aim_offset())
	
	#_-bullet params
	tab.set_BulletSpeed_field(emitter.get_bullet_speed())
	tab.set_BulletLifespan_field(emitter.get_bullet_lifespan())
	
	return

#function to update the save path of emitter
#params: tab that was updated and new value
#return: null
func save_File(tab,path):
	tab_emitter_map[tab].save(path)
	return

#function to delete the current node
#params: tab that was updated
#return: null
func delete_Emitter(tab):
	tab_emitter_map[tab].queue_free()
	editor.set_tab_hidden(int(tab.name),true)
	return
