extends MarginContainer


func _physics_process(delta):
	$HBoxContainer/VBoxContainer/FPS.text = "FPS: "+ str(Performance.get_monitor(Performance.TIME_FPS))
	$HBoxContainer/VBoxContainer/Memory.text = "Memory_Use: " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1048576))+"MB"
