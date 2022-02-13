extends Tabs

#GLOBALS
var connectedEmitter

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_emitter(emitter):
	connectedEmitter = emitter


func _on_SprayCooldown_Input_value_changed(value):
	connectedEmitter.spray_cooldown = value
