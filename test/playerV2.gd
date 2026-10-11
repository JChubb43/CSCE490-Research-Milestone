extends CharacterBody2D
signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# detect collisions
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider.is_in_group("mobs"):
			hide()
			hit.emit()
			$CollisionShape2D.set_deferred("disabled", true) #i-frames
			# .set_deferred avoids errors of disabling in middle of collision processing

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
