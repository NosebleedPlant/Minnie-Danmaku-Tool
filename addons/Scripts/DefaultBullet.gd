extends Sprite

#_EDITABLE PARAMS
var bullet_speed = 0			#speed of bullet
var bullet_life_span = 0		#life span of a single bullet

#_GLOBALS
var life_time = 0				#how long this bullet has been alive
var bullet_radius = 0			#radius of bullet hitbox
var collided = false			#has a collision happened
var player_position				#players current position

#_GLOBALS
onready var motion_vector = Vector2(cos(self.rotation),sin(self.rotation))*bullet_speed		#precomputes motion vector to avoid trig computation every frame 

#INITALIZATION METHOD:
#
#initalizes the bullet before it enters scene
func init(pos,angle,speed,lifespan):
	self.position = pos
	self.rotation = angle
	bullet_speed = speed
	bullet_life_span = lifespan

#_MAIN:
func _process(delta):
	_extra_behaviour(delta)
	move(delta)
	if(bullet_life_span!=0):
		age(delta)
	if(player_position):
		collision_Detection(player_position)
	return

#_VIRTUAL FUNCTIONS:
func _extra_behaviour(delta):
	pass

#_HELPER FUNCTIONS:
#bullet movement
#param:delta(time between frames)
#return: null
func move(delta):
	self.position += motion_vector*delta
	return

#deletes bullet after age exceeded
#param:delta(time between frames)
#return: null
func age(delta):
	life_time+=delta
	if(life_time>=bullet_life_span):
		self.queue_free()
	return

#collision detection
#param:playerVect(Vectr2 of player position)
#return: null
func collision_Detection(playerVec:Vector2):
	if(self.position.distance_to(playerVec)<=bullet_radius):
		collided = true;
		self.queue_free()
	return

#_SETTER GETTERS:
#sets the player position
#param: Vectr2 of player position
#return: null
func set_PlayerPosition(playerVec:Vector2):
	player_position = playerVec

