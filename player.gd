extends Area2D
# player can emit this when it collides with an enemy
signal hit

@export var speed = 400 # how fast player moves (pixels/sec)
var screen_size # size of game window


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# move player by velocity and delta since last process call, but make sure
	# it doesn't move off screen.
	# position is an instance variable of Node2D, which is what the Player node is
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# since the animation frames show the player walking right, we want
		# to flip it horizontally if they're walking left
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# same thing for if we're moving down, as animation is moving up
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # player disappears after getting hit
	# we can emit this player's signal
	hit.emit()
	
	# we set the collision shape to disabled so enemies no longer collide with it.
	# we have to set it deferred (eventually, async) as we can't directly change physics
	# properties in a physics callback. set_deferred waits til its safe to do so
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
