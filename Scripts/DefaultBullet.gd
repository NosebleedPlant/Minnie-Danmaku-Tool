extends Sprite
#_EDITABLE PARAMS
var bullet_radius = 10
var bullet_speed = 100
var life_span = null
var life_time = 0
var collided = false
var player_position



func _process(delta):
	move(delta)
	if(life_span):
		age(delta)
	if(player_position):
		collision_Detection(player_position)
	return

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
	if(life_time>=life_span):
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

#SETTER GETTERS:

#sets the player position
#param:delta(Vectr2 of player position)
#return: null
func _setPlayerPosition(playerVec:Vector2):
	player_position = playerVec
