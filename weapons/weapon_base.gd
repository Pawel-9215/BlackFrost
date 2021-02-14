extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_owner()
var is_attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.name)


func _on_Player_attack():
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
