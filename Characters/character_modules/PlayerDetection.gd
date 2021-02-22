extends Area2D


var player = null
var player_in_fov = false
const MAX_DETECTION_RANGE = 84
var player_detected setget player_detection 

onready var creature = get_parent()
signal player_status


# Called when the node enters the scene tree for the first time.

func _ready():
	player_detection(false)

func player_detection(value):
	if value != player_detected:
		player_detected = value
		#print("player detected: ", player_detected)
		emit_signal("player_status", player_detected)
	else:
		player_detected = value
	


func _physics_process(_delta):
	if player != null:
		player_detection(player_in_LOS())
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func player_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(creature.global_position, 
											player.global_position, 
											[self, creature],
											collision_mask)
											
	if not LOS_obstacle:
		return false
		
	var distance_to_player = player.global_position.distance_to(creature.global_position)
	
	if LOS_obstacle.collider == player and distance_to_player <= MAX_DETECTION_RANGE:
		return true
	else:
		return false

func _on_PlayerDetection_body_entered(body):
	player = body
	#print("In Fov")
	player_in_fov = true


func _on_PlayerDetection_body_exited(_body):
	player = null
	#print("Not in FOV")
	player_in_fov = false
	player_detection(false)
