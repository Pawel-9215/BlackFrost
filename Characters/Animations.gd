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
onready var velocity = character.velocity
onready var animationTree = $AnimationTree
onready var AnimationState = $AnimationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(_delta):
	update_animation()
	if character.velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func update_animation():
	velocity = character.velocity
	var mouse_vector = get_global_mouse_position() - global_position
	mouse_vector = mouse_vector.normalized()
	animationTree.set("parameters/Idle/blend_position", velocity.normalized())
	animationTree.set("parameters/Run/blend_position", velocity.normalized())
	# animationTree.set("parameters/Attack/blend_position", mouse_vector)
	if velocity.length() > 5:
		AnimationState.travel("Run")
	else:
		AnimationState.travel("Idle")
		
func changed_state(state):
	if state == DEATH:
		$AnimatedSprite.play("death")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
