extends Node

@export var mob_scene : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	# choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# set mob's direction perpendicular to path
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set mob's position to random
	mob.position = mob_spawn_location.position
	
	# add some randomness to the direction a bit
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	

# increment the player's score by 1 per second they live
func _on_score_timer_timeout():
	score += 1

# start the gaaaaaaame
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
