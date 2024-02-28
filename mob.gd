extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# when mobs move off the screen, queue them to be removed from the game
func _on_visible_on_screen_notifier_2d_screen_exited():
	# setup a one-shot timer to wait 1 second after mob has exited the screen
	# to make them smoothly go fully off-screen before freeing them
	await get_tree().create_timer(1.0).timeout
	queue_free()
