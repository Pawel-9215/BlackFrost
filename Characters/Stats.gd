extends Node

export var character_sheet = {"health": 20,
	"durability": 12,
	"damage": 2}
var current_health setget set_health

signal no_health

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = character_sheet["health"]
	
func set_health(value):
	current_health = value
	if current_health <= 0:
		emit_signal("no_health")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
