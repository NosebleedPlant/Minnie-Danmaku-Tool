extends Node2D

#_PRELOADS
var _Emitter = preload("res://Scenes/Emitter.tscn")		#emitter
var _Editor = preload("res://UI/Editor.tscn")			#the editor menu
var _Tab = preload("res://UI/Tab.tscn")					#tab in editor

#_GLOBALS:
var emitter_count = 0
var editor
#_MAIN:
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("mouse_right"):
		#create new emitter at location of right click
		var emitter = _Emitter.instance()
		emitter_count+=1
		emitter.position = get_global_mouse_position()#set position of emitter to click location
		emitter.init(get_global_mouse_position(),"Default_Emitter_"+str(emitter_count))
		self.add_child(emitter)
		
		#create tabs in editor for each new emitter spawned
		if(emitter_count==1):#first emitter create both editor and tab
			editor = _Editor.instance()
			var tab = editor.get_node("Editor/Tab")
			self.add_child(editor)
			tab.init(emitter)
		elif(emitter_count>1):#after that just create tab
			var tab = _Tab.instance()
			editor.get_node("Editor").add_child(tab)
			tab.init(emitter)
	return
