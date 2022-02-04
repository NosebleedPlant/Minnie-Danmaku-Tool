extends Node2D

#LOADED DEPENDENCIES
var _Emitter = preload("res://Scene/Default_Emitter.tscn")
var _Editor = preload("res://Scene/UI Scenes/EditorContainer.tscn")
var _Tab = preload("res://Scene/UI Scenes/EditorTab.tscn")

#GLOBALS
var root:Node2D
var editor
var emitter_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Danmaku_Base")
	return
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_right"):
		var emitter = _Emitter.instance()
		var pos = get_global_mouse_position()
		emitter.init(pos)
		root.add_child(emitter)
		if(emitter_count>=1):
			var tab = _Tab.instance()
			tab.name = str(emitter_count)
			editor.get_node("/root/Danmaku_Base/UI/TabContainer").add_child(tab)
		elif (emitter_count<1):
			editor = _Editor.instance()
			editor.get_node("TabContainer/EditorTab").set_emitter(emitter)
			root.add_child(editor)
			editor.get_node("/root/Danmaku_Base/UI/TabContainer/EditorTab").name = str(emitter_count)
		emitter_count+=1
	return
