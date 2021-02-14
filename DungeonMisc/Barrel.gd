extends StaticBody2D

var Health = 20

func Hurt(from):
	print("got hit")
	Health -= 4
	$HitParticles.direction = global_position-from
	$HitParticles.emitting = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	var area_position = area.get_parent().get_global_position()
	Hurt(area_position)
