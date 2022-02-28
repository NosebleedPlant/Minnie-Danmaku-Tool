extends "res://addons/Scripts/DefaultBullet.gd"

var ineversion_time = 0
onready var ineversion_trigger = 3

func _extra_behaviour(delta):
	invert(delta)

func invert(delta):
	ineversion_time+=delta
	if(ineversion_time>=ineversion_trigger):
		motion_vector = motion_vector*-1
		ineversion_time = 0
	return
