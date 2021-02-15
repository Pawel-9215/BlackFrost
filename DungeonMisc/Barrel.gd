extends StaticBody2D

var Health = 20

func Hurt(from):
	play_sound()
	print("got hit")
	Health -= 4
	$HitParticles.direction = global_position-from
	$HitParticles.restart()
	#$HitParticles.emitting = true
	$AnimationPlayer.play("hit")
	if Health <= 10:
		$Sprite.play("hurt")
	if Health <= 0:
		# $Hurtbox/CollisionShape2D.disabled = true
		$Hurtbox.queue_free()
		$CollisionShape2D.queue_free()
		$Sprite.play("destroy")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



#func _process(delta):
#	if Health <= 0:
#		$Sprite.animation.


func _on_Hurtbox_area_entered(area):
	var area_position = area.get_owner().get_global_position()
	Hurt(area_position)


func _on_Sprite_animation_finished():
	if $Sprite.animation == "destroy":
		print("destroying self")
		queue_free()
		
func play_sound():
	$Audio.play()
