extends Tabs
#_GLOBALS:
var connectedEmitter

#_SETTER GETTERS:
#sets the emitter that this tab is responsible for
#param:emitter
#return: null
func set_emitter(emitter):
	connectedEmitter = emitter

#_SYSTEM OVERRIEDS:
func _on_SprayCooldown_Input_value_changed(value):
	connectedEmitter.spray_cooldown = value
