extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.name)


func _on_Player_attack():
	print("Attack!")
	$AnimationPlayer.play("Attack")

func end_attack():
	player.set_state("move")
