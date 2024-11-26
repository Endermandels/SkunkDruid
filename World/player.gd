extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var sprite = $Sprite2D
@onready var spray = $Spray

func _process(_delta: float) -> void:
	# Emit spray particles in direciont of mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		spray.emitting = true
		var direction = global_position.direction_to(get_global_mouse_position())
		spray.process_material.direction.x = direction.x
		spray.process_material.direction.y = direction.y
	else:
		spray.emitting = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.flip_h = false
			spray.process_material.direction.x = 1
		else:
			sprite.flip_h = true
			spray.process_material.direction.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
