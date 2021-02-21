extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_owner()
var is_attacking = false
onready var audioplayer = $AudioStreamPlayer2D
onready var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.name)
	$Hitbox.damage = damage


func _on_Player_attack():
	play_swoosh()
	if not is_attacking:
		is_attacking = true
		print("Attack!")
		$AnimationPlayer.play("Attack")
	else:
		pass

func end_attack():
	player.set_state("move")
	print("End attack")
	is_attacking = false

func play_swoosh():
	var name = "swoosh" + str(randi() % 5 + 1) + ".wav"
	audioplayer.stream = load("res://SFX/swooshes/"+name)
	audioplayer.play()
	print(name)
