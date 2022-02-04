extends Node2D

#_PRELOADS
var _Emitter = preload("res://Scenes/Emitter.tscn")
var _Editor = preload("res://UI/Editor.tscn")
var _Tab = preload("res://UI/Tab.tscn")

#_GLOBALS:
var emitter_count = 0
var editor
#_MAIN:
func _process(delta):
	if Input.is_action_just_pressed("mouse_right"):
		#create new emitter at location of right click
		var emitter = _Emitter.instance()
		emitter.position = get_global_mouse_position()#set position of emitter to click location
		self.add_child(emitter)
		emitter_count+=1
		
		#create tabs in editor for each new emitter spawned
		if(emitter_count==1):#first emitter create both editor and tab
			editor = _Editor.instance()
			editor.get_node("Editor/Tab").set_emitter(emitter)
			self.add_child(editor)
			editor.get_node("Editor/Tab").name = str(emitter_count)
		elif(emitter_count>1):#after that just create tab
			var tab = _Tab.instance()
			tab.name = str(emitter_count)
			editor.get_node("Editor").add_child(tab)
	return
