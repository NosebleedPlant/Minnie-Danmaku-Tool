extends Node2D

#LOADED DEPENDENCIES
var _Bullet = preload("res://Scene/Default_Bullet.tscn")

#EDITABLE PARAMETERS:
export (NodePath)var playerNodePath
#-transformation params:
export (float, EXP,-360,360)var rotation_rate = 0#rate of eimiter rotaiotn
export (Vector2)var bullet_offset#offset from emitter origin
#-shot params:
export (float)var spray_cooldown = 1#cooldown between shots
export var spray_count = 1#bulletcount in a single spray
export (float)var spread_width=0#spread width between bullets
export (float, EXP,-360,360)var spread_angle=0 setget set_spread_angle#spread angle between bullets
#-aiming params:
export (bool)var aim_enabled = false
export (Vector2)var aim_offset#offset from player
export var aim_pause = 0#calls to player position per second

#GLOBALS
var parent:Node2D
var shot_timer = spray_cooldown
var shoot_period = 0
var spread_enabled = false
var player
var aim_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = self.get_parent()
	if(spray_count > 1&&spread_angle!=0.0):
		spread_enabled = true
	if(playerNodePath):
		player = get_node(playerNodePath)
	else:
		push_error("Player path required")
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = player.position
	
	aim(delta,player_position) if aim_enabled else rotate(delta)
	shoot(delta)
	bullet_poll(player_position)
	return

func rotate(delta):
	self.rotation += rotation_rate*delta
	if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
		self.rotation_degrees = 0
	return

#@TODO: lerp to position rather then snapping to it
func aim(delta,player_position):
	aim_timer += delta
	if(aim_timer>=aim_pause):
		look_at(player_position + aim_offset)
		aim_timer =0
	return

func shoot(delta):
	shot_timer += delta
	var childBullets = []
	if(shot_timer>=spray_cooldown):
		childBullets = instanceBullet(childBullets)
		childBullets = positionBullet(childBullets)
		childBullets = rotateBullet(childBullets)
		for bullet in childBullets:
			parent.add_child(bullet)
			bullet.add_to_group("bullet_pool")
		shot_timer = 0
	return

func bullet_poll(player_position):
	parent.get_tree().call_group("bullet_pool","set_player_pos",player_position)

func instanceBullet(childBullets):
	for i in spray_count:
		var bullet = _Bullet.instance()
		bullet.add_to_group("bullets")
		bullet.position = self.position+bullet_offset
		bullet.rotation = self.rotation
		childBullets.append(bullet)
	return childBullets

func positionBullet(childBullets):
	if(spray_count > 1&&spread_width>0):
		var spread = (spread_width/2)*-1
		var spread_increment = spread_width/(spray_count-1)
		var angle = self.rotation+deg2rad(90)
		for bullet in childBullets:
			var new_pos = Vector2(spread*cos(angle),spread*sin(angle))
			bullet.translate(new_pos)
			spread+=spread_increment
	return childBullets

func rotateBullet(childBullets):
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

func set_player_path(path):
	playerNodePath = path
	player = get_node(playerNodePath)
