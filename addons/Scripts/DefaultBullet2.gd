extends "res://addons/Scripts/DefaultBullet.gd"

func _ready():
	bullet_speed = 1000			#speed of bullet
	bullet_life_span = null		#life span of a single bullet
	motion_vector = Vector2(cos(self.rotation),sin(self.rotation))*bullet_speed
	print("this")
	
