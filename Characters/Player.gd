extends "res://Characters/TemplateCharacter.gd"

var velocity = Vector2()
onready var animationTree = $AnimationTree
onready var AnimationState = $AnimationTree.get("parameters/playback")

func _ready():
	print("Hello World")
	

func _physics_process(_delta):
	update_movement()
	velocity = move_and_slide(velocity)
	update_lookat()

func update_movement():
	
	var input_vector = Vector2()
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.clamped(1.0)
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		AnimationState.travel("Run")
		velocity += input_vector * SPEED
		velocity = velocity.clamped(MAX_SPEED*input_vector.length())
	else:
		AnimationState.travel("Idle")
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		
	
func update_lookat():
	
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.y < global_position.y:
		$Hands.show_behind_parent = true
	else:
		$Hands.show_behind_parent = false
		
	$Hands.look_at(mouse_pos)
