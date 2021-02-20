extends "res://Characters/TemplateCharacter.gd"

const KNOCKBACK_FORCE = 100

export var health = 20
var velocity = Vector2()

enum {
	MOVE,
	ATTACK,
	KNOCKBACK,
	DEATH,
}

var state = MOVE

func _ready():
	pass # Replace with function body.

func set_state(set_state):
	var in_state = {
		"move": MOVE,
		"attack": ATTACK,
		"knockback": KNOCKBACK,
		"death": DEATH,
	}
	state = in_state[set_state]
	
	
func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		KNOCKBACK:
			knockback_state()
		DEATH:
			death_state()

func move_state():
	velocity = move_and_slide(velocity)

func death_state():
	$AnimatedSprite.play("death")

func attack_state():
	pass

func _on_Hurtbox_area_entered(area):
	var area_position = area.get_owner().get_global_position()
	hurt(area_position)

func hurt(area_pos):
	print("Auch!!!")
	velocity = ($AnimatedSprite.global_position - area_pos).normalized() * KNOCKBACK_FORCE
	if health > 0:
		set_state("knockback")
	else:
		set_state("death")
	
func knockback_state():
	
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	print(velocity)
	velocity = move_and_slide(velocity)
	if velocity.length()<= 5:
		print("done")
		velocity = Vector2.ZERO
		set_state("move")
	
	
