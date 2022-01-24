extends Node2D

#LOADED DEPENDENCIES
var _Emitter = preload("res://Scene/Default_Emitter.tscn")

#GLOBALS
var root:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Danmaku_Base")
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_right"):
		print("hit")
		var emitter = _Emitter.instance()
		var pos = get_global_mouse_position()
		emitter.init(pos)
		root.add_child(emitter)
	return
