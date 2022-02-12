extends Sprite

#_PRELOADS:
#
var bullet_adress = "res://Scenes/Provided Bullets/Bullet.tscn"
var _Bullet = preload("res://Scenes/Provided Bullets/Bullet.tscn")

#_EDITABLE PARAMS:
#
var spray_cooldown = 0.5					#cooldown between shots
var rotation_rate = 0						#rate of eimiter rotaiotn
#_-spread params
var cone_spread_enabled = false				#cone spread enabled
var spray_count = 1							#bulletcount in a single spray
var spread_angle=0							#spread angle between bullets
var spread_width=0							#spread width between bullets
#_-aim params
var aim_enabled = false						#aiming at player
var aim_pause = 0							#calls to player position per second
var aim_offset = Vector2.ZERO				#offset from player


#_GLOBALS:
onready var root = get_tree().get_root().get_child(0)				#for easy access to root
onready var player = get_parent().find_node("Player") 	#for easy access to player node
var shot_timer = spray_cooldown							#timer between shots
var aim_timer = 0										#delay between re-aim
var repositioning_emitter = false						#indicates if repositioning
var rotating_emitter = false							#indicates if adjusting rotate

#_MAIN:
#
func _process(delta):
	# warning-ignore:standalone_ternary
	aim(delta,player.position) if aim_enabled else rotate(delta)
	shoot(delta)
	return

#_HELPER FUNCTIONS:
#
#initalization function sets starting vals
#param:spawn position, name of eitter
#return: null
func init(pos,name_str):
	self.position = pos
	self.name = name_str

#aims at player
#param:delta(time between frames), player position vector
#return: null
#@TODO: aim offset not functioning correctly
func aim(delta,player_position):
	aim_timer += delta
	if(aim_timer>=aim_pause):
		look_at(player_position + aim_offset)
		aim_timer =0
	return

#rotates emitter
#param:delta(time between frames)
#return: null
func rotate(delta):
	self.rotation += rotation_rate*delta
	if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
		self.rotation_degrees = 0
	return

#responsible for shooting bullets
#param:delta(time between frames)
#return: null
func shoot(delta):
	shot_timer += delta
	var childBullets = []
	if(shot_timer>=spray_cooldown):
		childBullets = instance_Bullet(childBullets)
		childBullets = position_Bullet(childBullets)
		childBullets = rotate_Bullet(childBullets)
		for bullet in childBullets:
			root.add_child(bullet)
		shot_timer = 0
	return

#instantites bullet and sets correct transforms
#param:array of bullets that are the child of this emitter
#return: same as above
func instance_Bullet(childBullets):
	for i in spray_count:
		var bullet = _Bullet.instance()
		bullet.position = self.position
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

#transforms rotation of bullet trajectory to match direction of emitter
#param:array of bullets that are the child of this emitter
#return: same as above
func rotate_Bullet(childBullets):
	if(cone_spread_enabled):
		var spread_angle_increment = spread_angle/(spray_count-1)
		var curr_angle = (spread_angle/2)*-1
		for bullet in childBullets:
			bullet.rotation += curr_angle
			curr_angle+=spread_angle_increment
	return childBullets

#save the params for emitter
#param:save file name
#return: null
func save(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.WRITE)
		file.store_var(position)
		file.store_var(rotation)
		file.store_var(bullet_adress)
		file.store_var(spray_cooldown)
		file.store_var(rotation_rate)
		file.store_var(cone_spread_enabled)
		file.store_var(spray_count)
		file.store_var(spread_angle)
		file.store_var(spread_width)
		file.store_var(aim_enabled)
		file.store_var(aim_pause)
		file.store_var(aim_offset)
		file.close()
	return

#load the params for emitter
#param:save file name
#return: null
func load_Emitter(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		position = file.get_var()
		rotation = file.get_var()
		bullet_adress = file.get_var()
		spray_cooldown = file.get_var()
		rotation_rate = file.get_var()
		cone_spread_enabled = file.get_var()
		spray_count = file.get_var()
		spread_angle = file.get_var()
		spread_width = file.get_var()
		aim_enabled = file.get_var()
		aim_pause = file.get_var()
		aim_offset = file.get_var()
		file.close()
	return

#_SIGNAL EVENTS:
#
func on_Input_Event(viewport, event, shape_idx):
	root.adjustment_Input(self,event)
