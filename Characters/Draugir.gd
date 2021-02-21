extends "res://Characters/TemplateCharacter.gd"

const KNOCKBACK_FORCE = 150

onready var stats = $Stats
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
	if $AnimatedSprite.frame == 5:
		$AnimatedSprite.stop()

func attack_state():
	pass

func _on_Hurtbox_area_entered(area):
	var area_position = area.get_owner().get_global_position()
	hurt(area_position)

func hurt(area_pos):
	stats.current_health -= 4
	print("Auch!!!")
	velocity = ($AnimatedSprite.global_position - area_pos).normalized() * KNOCKBACK_FORCE
	if stats.current_health > 0:
		set_state("knockback")
	else:
		set_collision_mask_bit(0, false)
		z_index -= 1
		set_state("death")
		$gushing.restart()
	$blood.direction = ($AnimatedSprite.global_position - area_pos).normalized()
	$blood.restart()
	
func knockback_state():
	
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	print(velocity)
	velocity = move_and_slide(velocity)
	if velocity.length()<= 5:
		print("done")
		velocity = Vector2.ZERO
		set_state("move")
	
	
