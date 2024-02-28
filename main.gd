extends Node

@export var mob_scene : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# every node with the group "mobs" will have queue_free() called on it.
	# this will wipe new games of old mobs
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	# choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# set mob's direction perpendicular to path
	var direction = mob_spawn_location.rotation + PI / 2
	
	# calculate the opposite direction (off screen), then move
	# the mob a bit in that direction to allow for smoother entering of mobs
	var opposite_dir = direction + PI
	var pos = mob_spawn_location.position
	var opposite_pos = Vector2.from_angle(opposite_dir)
	
	# set mob's position to random
	mob.position = mob_spawn_location.position + (opposite_pos * 30.0)
	
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
	$HUD.update_score(score)

# start the gaaaaaaame
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
