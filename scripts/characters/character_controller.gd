extends CharacterBody3D

const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

@onready var cam_transform : Transform3D = $PhantomCamera3D.transform

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir : Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		
		# Apply the camera's Y rotation to the input direction
		var rotation_y : float = cam_transform.basis.get_euler().y
		var direction : Vector3 = (Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3(0, 1, 0), rotation_y).normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		var dec_rate : float = SPEED * 0.07
		velocity.x = move_toward(velocity.x, 0, dec_rate)
		velocity.z = move_toward(velocity.z, 0, dec_rate)

	move_and_slide()
