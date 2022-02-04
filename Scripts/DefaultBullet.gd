extends Sprite
#_EDITABLE PARAMS
var bullet_radius = 10			#radius of bullet hitbox
var bullet_speed = 100			#speed of bullet
var bullet_life_span = null		#life span of a single bullet
var life_time = 0				#how long this bullet has been alive
var collided = false			#has a collision happened
var player_position				#players current position

#_MAIN:
func _process(delta):
	move(delta)
	if(bullet_life_span):
		age(delta)
	if(player_position):
		collision_Detection(player_position)
	return


#_HELPER FUNCTIONS:
#bullet movement
#param:delta(time between frames)
#return: null
func move(delta):
	var motionVector = Vector2.ONE
	motionVector.x *= cos(self.rotation)*bullet_speed
	motionVector.y *= sin(self.rotation)*bullet_speed
	self.position += motionVector*delta
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
		print("hit")
		self.queue_free()
	return

#_SETTER GETTERS:
#sets the player position
#param:delta(Vectr2 of player position)
#return: null
func _setPlayerPosition(playerVec:Vector2):
	player_position = playerVec

