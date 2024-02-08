class_name Player extends CharacterBody3D

var alive = true

@onready var playermodel = $Node3D/PlayerModel

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not alive:
		if playermodel.run:
				playermodel.switch_state()
		rotation_degrees.x = 90
		rotation_degrees.y += 0.5
		global_position.y += 0.02
		$orb.visible = true
	else:
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = Vector3(input_dir.x, 0, input_dir.y).normalized() # (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if not playermodel.run:
				playermodel.switch_state()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			look_at(Vector3.FORWARD.rotated(Vector3.UP, rotation.y).lerp(direction*-1 , 0.5) + position)
			if Vector3.FORWARD.rotated(Vector3.UP, rotation.y).lerp(direction*-1 , 0.5).length() < 0.01:
				look_at(direction*-1 + position)
		else:
			if playermodel.run:
				playermodel.switch_state()
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
		
		for col_idx in get_slide_collision_count():
			var col := get_slide_collision(col_idx)
			if col.get_collider() is RigidBody3D:
				col.get_collider().apply_central_impulse(-col.get_normal() * 0.6)
				col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())
