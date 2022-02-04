extends Sprite
#_PRELOADS
var _Bullet = preload("res://Scenes/Provided Bullets/Bullet.tscn")

#_EDITABLE PARAMS:
var spray_cooldown = 1						#cooldown between shots
var rotation_rate = 0						#rate of eimiter rotaiotn
var spray_count = 1							#bulletcount in a single spray
#_-spread params
var cone_spread_enabled = false				#cone spread enabled
var spread_width=0							#spread width between bullets
var spread_angle=0 setget set_spread_angle	#spread angle between bullets
#_-aim params
var aim_enabled = false						#aiming at player
var aim_offset								#offset from player
var aim_pause = 0							#calls to player position per second

#_GLOBALS:
onready var root = get_tree().get_root()							#for easy access to root
onready var player = get_tree().get_root()							#for easy access to player node
var shot_timer = spray_cooldown										#timer between shots
var aim_timer = 0													#delay between re-aim

#_MAIN:
func _process(delta):
# warning-ignore:standalone_ternary
	aim(delta,player.position) if aim_enabled else rotate(delta)
	shoot(delta)
	return

#_HELPER FUNCTIONS:
#aims at player
#param:delta(time between frames), player position vector
#return: null
func aim(delta,player_position):
	aim_timer += delta
	if(aim_timer>=aim_pause):
		look_at(player_position + aim_offset)
		aim_timer =0
	return

#instantites bullet and sets correct positions
#param:delta(time between frames)
#return: null
func shoot(delta):
	shot_timer += delta
	var childBullets = []
	if(shot_timer>=spray_cooldown):
		childBullets = instance_Bullet(childBullets)
		childBullets = position_Bullet(childBullets)
		childBullets = adjust_Bullet_Trajectory(childBullets)
		for bullet in childBullets:
			root.add_child(bullet)
			bullet.add_to_group("bullet_pool")
		shot_timer = 0
	return

#rotates emitter
#param:delta(time between frames)
#return: null
func rotate(delta):
	self.rotation += rotation_rate*delta
	if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
		self.rotation_degrees = 0
	return

#instantites bullet and sets correct transforms
#param:array of bullets that are the child of this emitter
#return: same as above
func instance_Bullet(childBullets):
	for i in spray_count:
		var bullet = _Bullet.instance()
		bullet.add_to_group("bullets")
		bullet.position = self.position#+bullet_offset
		bullet.rotation = self.rotation
		childBullets.append(bullet)
	return childBullets

#transforms position of bullet
#param:array of bullets that are the child of this emitter
#return: same as above
func position_Bullet(childBullets):
	if(cone_spread_enabled):
		var spread = (spread_width/2)*-1
		var spread_increment = spread_width/(spray_count-1)
		var angle = self.rotation+deg2rad(90)
		for bullet in childBullets:
			var new_pos = Vector2(spread*cos(angle),spread*sin(angle))
			bullet.translate(new_pos)
			spread+=spread_increment
	return childBullets

#transforms rotation of bullet trajectory
#param:array of bullets that are the child of this emitter
#return: same as above
func adjust_Bullet_Trajectory(childBullets):
	if(cone_spread_enabled):
		var spread_angle_increment = spread_angle/(spray_count-1)
		var curr_angle = (spread_angle/2)*-1
		for bullet in childBullets:
			bullet.rotation += curr_angle
			curr_angle+=spread_angle_increment
	return childBullets

#_SETTER GETTERS:
#instantites bullet and sets correct positions
#param:angle
#return: null
func set_spread_angle(degs):
	spread_angle = deg2rad(degs)
	return
