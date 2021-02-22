extends "res://Characters/TemplateCharacter.gd"

const KNOCKBACK_FORCE = 150

onready var stats = $Stats
var velocity = Vector2()
var player_detected = false

enum {
	IDLE,
	CHASE,
	WANDER,
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
		"idle": IDLE,
		"wander": WANDER,
		"chase": CHASE,
		"move": MOVE,
		"attack": ATTACK,
		"knockback": KNOCKBACK,
		"death": DEATH,
	}
	state = in_state[set_state]
	print(set_state)
	
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		KNOCKBACK:
			knockback_state()
		DEATH:
			death_state()
		IDLE:
			pass
		WANDER:
			pass
		CHASE:
			chase_player(delta)
			
func find_default_state():
	if player_detected:
		set_state("chase")
	else:
		set_state("idle")

func chase_player(delta):
	var player = $PlayerDetection.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction*MAX_SPEED, SPEED * 3 * delta)
		velocity = move_and_slide(velocity)
		#$PlayerDetection.rotation = direction.get_angle_to()

func idle(): 
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	velocity = move_and_slide(velocity)
	
func seek_player():
	pass

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
	var damage = area.damage
	print(damage)
	hurt(area_position, damage)

func hurt(area_pos, damage):
	stats.current_health -= damage
	print("Auch!!!")
	velocity = ($AnimatedSprite.global_position - area_pos).normalized() * KNOCKBACK_FORCE
	if stats.current_health > 0:
		set_state("knockback")
		$Speech.stream = load("res://SFX/characters/growls/growl1_hurt.wav")
		$Speech.play()
		$Sounds.stream = load("res://SFX/thump/hit_metal.wav")
		$Sounds.play()
	else:
		$Speech.stream = load("res://SFX/characters/growls/growl1_die.wav")
		$Speech.play()
		$Sounds.stream = load("res://SFX/thump/hit_meat.wav")
		$Sounds.play()
		set_collision_mask_bit(0, false)
		z_index -= 1
		$Shadow.queue_free()
		set_state("death")
		$gushing.restart()
		$PlayerDetection.queue_free()
	$blood.direction = ($AnimatedSprite.global_position - area_pos).normalized()
	$blood.restart()
	
func knockback_state():
	
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	#print(velocity)
	velocity = move_and_slide(velocity)
	if velocity.length()<= 5:
		print("done")
		velocity = Vector2.ZERO
		find_default_state()
	
	


func _on_Stats_no_health():
	$Hurtbox.queue_free()


func _on_PlayerDetection_player_status(status):
	player_detected = status
	print("Player detection: ", status)
	if status:
		set_state("chase")
	else:
		set_state("idle")
