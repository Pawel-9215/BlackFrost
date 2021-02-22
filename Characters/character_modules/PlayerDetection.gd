extends Area2D


var player = null
var player_in_fov = false
const MAX_DETECTION_RANGE = 84


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func player_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position, 
											player.global_position, 
											[self],
											collision_mask)
											
	if not LOS_obstacle:
		return false
		
	var distance_to_player = player.global_position.distance_to(global_position)
	
	if LOS_obstacle.collider == player and distance_to_player <= MAX_DETECTION_RANGE:
		return true
	else:
		return false

func _on_PlayerDetection_body_entered(body):
	player = body
	print("I see you!")
	player_in_fov = true


func _on_PlayerDetection_body_exited(body):
	player = null
	print("Now I don't")
	player_in_fov = false
