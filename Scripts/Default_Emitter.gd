extends Node2D

#LOADED DEPENDENCIES
var _Bullet = preload("res://Scene/Default_Bullet.tscn")

#EDITABLE PARAMETERS
export (float, EXP,-360,360)var rotation_rate = 1#rate of eimiter rotaiotn
export var spray_cooldown = 1#cooldown between shots
#bulletcount
#initial wait before shooting starts
#aiming

#THE FOLLOWING SHOULD BE RANDOMIZABLE AND PSEUDO RANDOMIZABLE
#starting angle
#spread type
#spread size
#x-offset from emitter
#y-offset from emitter
#bullet lifespan

#GLOBALS
var time = 0
var shoot_period = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation(delta)
	shoot(delta)

func rotation(delta):
	self.rotation += rotation_rate*delta
	if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
		self.rotation_degrees = 0

func shoot(delta):
	time += delta
	if(time>=spray_cooldown):
		var bullet = _Bullet.instance()
		bullet.position = self.position
		bullet.rotation = self.rotation
		self.get_parent().add_child(bullet)
		time = 0
