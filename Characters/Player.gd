extends "res://Characters/TemplateCharacter.gd"

var velocity = Vector2()
onready var animationTree = $AnimationTree
onready var AnimationState = $AnimationTree.get("parameters/playback")
var usingpad = false

enum {
	MOVE,
	ROLL,
	ATTACK,
	BREAK,
	KNOCKBACK,
}

var state = MOVE

signal attack

func _ready():
	set_label()


func set_label():
	var labels_states = {
		0:"move",
		1:"roll",
		2:"attack",
		3:"break"
	}
	$Label.text = labels_states[state]

func set_state(set_state):
	var in_state = {
		"move": MOVE,
		"roll": ROLL,
		"attack": ATTACK,
		"break": BREAK
	}
	state = in_state[set_state]
	set_label()
	
	
func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ROLL:
			pass
		BREAK:
			pass
	
func move_state():
	update_movement()
	velocity = move_and_slide(velocity)
	update_animation(usingpad)
	update_lookat(usingpad)
	actions()
	
func attack_state():
#	var mouse_vector = get_global_mouse_position() - global_position
#	mouse_vector = mouse_vector.normalized()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	velocity = move_and_slide(velocity)
#	animationTree.set("parameters/Attack/blend_position", mouse_vector)
	AnimationState.travel("Attack")
	
	
func _input(event): # check if player is using gamepad or keyboard and mouse
	if event is InputEventMouseMotion and usingpad:
		print("moved mouse")
		usingpad = false
	elif event is InputEventJoypadMotion and not usingpad:
		print("Joypad moved")
		usingpad = true

func actions():
	if Input.is_action_pressed("Attack"):
		emit_signal("attack")
		set_state("attack")

func update_movement():
	
	var input_vector = Vector2()
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.clamped(1.0)
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * SPEED
		velocity = velocity.clamped(MAX_SPEED*input_vector.length())
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	

func update_animation(is_usingpad):
	if not is_usingpad:
		var mouse_vector = get_global_mouse_position() - global_position
		mouse_vector = mouse_vector.normalized()
		animationTree.set("parameters/Idle/blend_position", mouse_vector)
		animationTree.set("parameters/Run/blend_position", mouse_vector)
		animationTree.set("parameters/Attack/blend_position", mouse_vector)
		if velocity.length() > 10:
			AnimationState.travel("Run")
		else:
			AnimationState.travel("Idle")
	else:
		pass

func update_lookat(is_usingpad):
	if not is_usingpad:
		var mouse_pos = get_global_mouse_position()
		
		if mouse_pos.y < global_position.y:
			$Hands.show_behind_parent = true
		else:
			$Hands.show_behind_parent = false
			
		$Hands.look_at(mouse_pos)
	else:
		pass
