extends Node2D

#_PRELOADS:
var _Bullet = preload("res://addons/Scenes/Provided Bullets/Bullet.tscn")

#_EDITABLE PARAMS:
#_-firing params
var fire_rate = 0.2					#cooldown between shots
var clip_size = 0					#shots before reload required
var reload_time = 0					#time it takes to roload
#_-rotation params
var angular_velocity = 0			#rate of eimiter rotaiotn in radians/frame
var angular_acceleration = 0		#rate at which the rotation speed changes
var max_angular_velocity = 0			#upper limit to rotation angle after which it flips
#_-spread params
var volley_size = 1					#bulletcount in a single volley
var spread_angle=0					#spread angle between bullets
var spread_width=0					#spread width between bullets
#_-array params
var array_count = 1
var array_angle = 0
#_-aim params
var aim_enabled = false				#aiming at player
var aim_pause = 0					#calls to player position per second
var aim_offset = 0					#offset from player
#-params bullet
var bullet_adress:String = "res://addons/Scenes/Provided Bullets/Bullet.tscn"
var bullet_speed = 100
var bullet_lifespan = 0

#_GLOBALS:
onready var player = get_parent().find_node("Player") 		#for easy access to player node
onready var controler = get_tree().get_root().get_child(0)	#for easy access to root
var aim_timer = 0											#delay between re-aim
var shot_timer = fire_rate									#timer between shots
var reload_timer = 0										#delay between reload
var shot_count = 0											#number of shots

#_MAIN:
#
#main function calls aim or rotate based on enabled profiles
#after targeting calls shoot function
func _process(delta):
	_move()
	_bound_Handler()
	# warning-ignore:standalone_ternary
	aim(delta,player.position) if aim_enabled else rotate(delta)
	if(cooldown(delta) and reload(delta)):
		shoot()
		clip_Managment()
	return

#_VIRTUAL FUNCTIONS:
#
#moves the emitter, meant to be overriden
#param: none
#return: null
func _move():
	pass

#handle going out of bounds, meant to be overriden
#param: none
#return: null
func _bound_Handler():
	pass

#_HELPER FUNCTIONS:
#
#aims at player
#param:delta(time between frames), player position vector
#return: null
func aim(delta,player_position):
	aim_timer += delta
	if(aim_timer>=aim_pause):
		look_at(player_position)
		self.rotation+=aim_offset
		aim_timer =0
	return

#rotates emitter
#param:delta(time between frames)
#return: null
func rotate(delta):
	if!(angular_velocity==0&&angular_acceleration==0):
		self.rotation += accelerate_Rotation(delta)
		if(self.rotation_degrees >= 360 or self.rotation_degrees <= -360):
			self.rotation_degrees = 0
	return
	
#increases/decreases rate of rotation
#param:delta(time between frames)
#return: updated angular velocity
func accelerate_Rotation(delta):
	angular_velocity += angular_acceleration*delta
	if(abs(angular_velocity)>abs(max_angular_velocity)&&(max_angular_velocity!=0)):
		angular_acceleration*=-1
	return angular_velocity

#checks to see if wait between shots has been completed
#param:delta(time between frames)
#return: boolean
func cooldown(delta):
	#uses seconds per bullet notaion for fire rate because it makes it easier to manage time
	shot_timer += delta
	if(shot_timer>=fire_rate):
		shot_timer = 0
		return true
	else: 
		return false

#checks to see if wait for reload has been completed reloads gun if it has
#param:delta(time between frames)
#return: boolean
func reload(delta):
	reload_timer -= delta
	if(reload_timer<=0):
		return true
	else: 
		return false

#responsible for shooting bullets
#param:delta(time between frames)
#return: null
func shoot():
	for array in array_count:
		var current_angle= self.rotation+(array*array_angle)
		var childBullets = []
		childBullets = instance_Bullet(childBullets,current_angle)
		childBullets = position_Bullet(childBullets,current_angle)
		childBullets = rotate_Bullet(childBullets)
		for bullet in childBullets:
			controler.add_child(bullet)
	return

#instantites bullet and sets correct transforms
#param:array of bullets that are the child of this emitter
#return: same as above
func instance_Bullet(childBullets,angle):
	for i in volley_size:
		var bullet = _Bullet.instance()
		bullet.init(self.position,angle,bullet_speed,bullet_lifespan)
		bullet.add_to_group("bullets")
		childBullets.append(bullet)
	return childBullets

#transforms position of bullet
#param:array of bullets that are the child of this emitter
#return: same as above
func position_Bullet(childBullets,angle):
	if(volley_size>1):
		var spread = (spread_width/2)*-1 #calculates right most point
		var spread_increment = spread_width/(volley_size-1)#claculates space between 2 bullets
		var adjusted_angle = angle+deg2rad(90)#adjusts the angle to account for godot 0 starting parrallel to x axis
		for bullet in childBullets:
			var new_pos = Vector2(spread*cos(adjusted_angle),spread*sin(adjusted_angle))#calculates new position
			bullet.translate(new_pos)
			spread+=spread_increment
	return childBullets

#transforms rotation of bullet trajectory to match direction of emitter
#param:array of bullets that are the child of this emitter
#return: same as above
func rotate_Bullet(childBullets):
	if(volley_size>1):
		var spread_angle_increment = spread_angle/(volley_size-1)#calculates the right most angle
		var curr_angle = (spread_angle/2)*-1#calculates angle between 2 bullets
		for bullet in childBullets:
			bullet.rotation += curr_angle
			curr_angle+=spread_angle_increment
	return childBullets

#checks to see if clip has been emptied forces reload when needed
#param:null
#return: null
func clip_Managment():
	shot_count += 1
	if(clip_size!=0 and shot_count>=clip_size):
		shot_count = 0#reload emitter
		reload_timer = reload_time #start reload wait next frame
	return

#load the params for emitter
#param:save file name
#return: null
func load_Emitter(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		name = file.get_var()
		position = file.get_var()
		rotation = file.get_var()
		
		#_-firing params
		fire_rate = file.get_var()
		clip_size = file.get_var()
		reload_time = file.get_var()
		
		#_-rotation params
		angular_velocity = file.get_var()
		angular_acceleration = file.get_var()
		max_angular_velocity = file.get_var()
		
		#_-spread params
		volley_size = file.get_var()
		spread_angle = file.get_var()
		spread_width = file.get_var()
		
		#_-array params
		array_count = file.get_var()
		array_angle = file.get_var()
		
		#_-aim params
		aim_enabled = file.get_var()
		aim_pause = file.get_var()
		aim_offset = file.get_var()
		
		#_-bullet params
		#load the new bullet
		bullet_adress = file.get_var()
		var directory = Directory.new();
		if directory.file_exists(bullet_adress):
			_Bullet = load(bullet_adress)
			
		bullet_speed = file.get_var()
		bullet_lifespan = file.get_var()

		file.close()
	return

#_SETTERS:
func set_name(value):
	name = value
func set_position_x(value):
	position.x = value
func set_position_y(value):
	position.y = value
func set_angle(value):
	if(value is Vector2):
		look_at(value)
	elif(value is float):
		rotation = deg2rad(value)
#_-firing params
func set_fire_rate(value):
	fire_rate = value
func set_clip_size(value):
	clip_size = value
func set_reload_time(value):
	reload_time = value
#_-rotation params
func set_angular_velocity(value):
	angular_velocity = deg2rad(value)
func set_angular_acceleration(value):
	angular_acceleration = deg2rad(value)
func set_max_angular_velocity(value):
	max_angular_velocity = deg2rad(value)
#_-spread params
func set_volley_size(value):
	volley_size = value
func set_spread_angle(value):
	spread_angle = deg2rad(value)
func set_spread_width(value):
	spread_width = value
#_-array params
func set_array_count(value):
	array_count = value
func set_array_angle(value):
	array_angle = deg2rad(value)
#_-aim params
func set_aim_enabled(value):
	aim_enabled = value
func set_aim_pause(value):
	aim_pause = value
func set_aim_offset(value):
	aim_offset = deg2rad(value)
#_-bullet params
func set_bullet(path):
	bullet_adress = path
	_Bullet = load(path)
func set_bullet_speed(value):
	bullet_speed = value
func set_bullet_lifespan(value):
	bullet_lifespan = value

#_GETTERS:
func get_name():
	return name
func get_poistion():
	return position
func get_angle():
	return rotation
#_-firing params
func get_fire_rate():
	return fire_rate
func get_clip_size():
	return clip_size
func get_reload_time():
	return reload_time
#_-rotation params
func get_angular_velocity():
	return angular_velocity
func get_angular_acceleration():
	return angular_acceleration
func get_max_angular_velocity():
	return max_angular_velocity
#_-spread params
func get_volley_size():
	return volley_size
func get_spread_angle():
	return spread_angle
func get_spread_width():
	return spread_width
#_-array params
func get_array_count():
	return array_count
func get_array_angle():
	return array_angle
#_-aim params
func get_aim_enabled():
	return aim_enabled
func get_aim_pause():
	return aim_pause
func get_aim_offset():
	return aim_offset
#_-bullet params
func get_bullet_speed():
	return bullet_speed
func get_bullet_lifespan():
	return bullet_lifespan
