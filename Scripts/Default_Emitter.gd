extends Node2D

#LOADED DEPENDENCIES
var _Bullet = preload("res://Scene/Default_Bullet.tscn")

#EDITABLE PARAMETERS:
#transformation params:
#export (float, EXP,-360,360)var starting_angle = 0 setget set_starting_angle
export (float, EXP,-360,360)var rotation_rate = 1#rate of eimiter rotaiotn
export (Vector2)var bullet_offset#offset from emitter origin
#shot params:
export (float)var spray_cooldown = 1#cooldown between shots
export var spray_count = 1#bulletcount in a single spray
export (float)var spread_width=0#spread width between bullets
export (float, EXP,-360,360)var spread_angle=0 setget set_spread_angle#spread angle between bullets
#modulate direction +-
#modulate speed?
#aiming params:
#export (bool)var aiming = false#aiming
#export var aim_offset = 0#offset from player
#export var aime_delay = 0#delay in player tracking
#unified bullet params:
#bullet lifespan
#destruct on exit
#bullet moves relative to emitter

#GLOBALS
var time = spray_cooldown
var shoot_period = 0
var spread_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation(delta)
	shoot(delta)
	return

func rotation(delta):
	self.rotation += rotation_rate*delta
	if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
		self.rotation_degrees = 0
	return

func shoot(delta):
	time += delta
	var childBullets = []
	if(time>=spray_cooldown):
		childBullets = instance_bullet(childBullets)
		childBullets = set_bullet_position(childBullets)
		if(spread_enabled):childBullets = set_bullet_rotation(childBullets)
		for bullet in childBullets:
			self.get_parent().add_child(bullet)
			bullet.add_to_group("bullet_pool")
		time = 0
	return

func instance_bullet(childBullets):
	for i in spray_count:
		var bullet = _Bullet.instance()
		bullet.position = self.position+bullet_offset
		bullet.rotation = self.rotation
		childBullets.append(bullet)
	return childBullets

func set_bullet_position(childBullets):
	if(spray_count > 1&&spread_width>0):
		var spread = (spread_width/2)*-1
		var spread_increment = spread_width/(spray_count-1)
		var angle = self.rotation+deg2rad(90)
		for bullet in childBullets:
			var new_pos = Vector2(spread*cos(angle),spread*sin(angle))
			bullet.translate(new_pos)
			spread+=spread_increment
	return childBullets

func set_bullet_rotation(childBullets):
	if(spread_enabled):
		var spread_angle_increment = spread_angle/(spray_count-1)
		var curr_angle = (spread_angle/2)*-1
		for bullet in childBullets:
			bullet.rotation += curr_angle
			curr_angle+=spread_angle_increment
	return childBullets

func set_spread_angle(degs):
	spread_angle = deg2rad(degs)
	if(spray_count > 1&&spread_angle!=0.0):
		spread_enabled = true
	else:
		spread_enabled = false
	return
