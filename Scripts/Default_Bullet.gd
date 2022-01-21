extends Node2D

#EDITABLE VALUES
export var bullet_radius = 0
export var bullet_acceleration = 100
#GLOBALS
var collided = false
var life_time = 0
var life_span = null
var player_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	if(life_span):
		age(delta)
#	if(player_position):
#		collision_detection(player_position)
	return

# Function that moves the bullet: Default is a straight line
func move(delta):
	var motionVector = Vector2.ONE
	motionVector.x *= cos(self.rotation)*bullet_acceleration
	motionVector.y *= sin(self.rotation)*bullet_acceleration
	self.position += motionVector*delta
	return

func age(delta):
	life_time+=delta
	if(life_time>=life_span):
		self.queue_free()
	return

func collision_detection(playerVec:Vector2):
	#collsions do not use Area 2D to reduce processing cost if using differently shaped bullet please change this code
	if(self.position.direction_to(playerVec)<=bullet_radius):
		collided = true;
		print("hit")
	return

func set_player_pos(playerVec:Vector2):
	player_position = playerVec

func test():
	print("hi")
