extends Node2D

enum {
	IDLE,
	CHASE,
	WANDER,
	MOVE,
	ATTACK,
	KNOCKBACK,
	DEATH,
}

onready var character = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(delta):
	if character.velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
func changed_state(state):
	if state == DEATH:
		$AnimatedSprite.play("death")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
