extends Node2D

#EDITABLE VALUES
export var bullet_acceleration = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	
# Function that moves the bullet: Default is a straight line
func move(delta):
	var motionVector = Vector2.ONE
	motionVector.x *= cos(self.rotation)*bullet_acceleration
	motionVector.y *= sin(self.rotation)*bullet_acceleration
	self.position += motionVector*delta
