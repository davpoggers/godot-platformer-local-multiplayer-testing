extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physi cs/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
var last_direction = 1  




func _ready() -> void:

	if name.is_valid_int():
		set_multiplayer_authority(name.to_int())
	

	$Camera2D.enabled = is_multiplayer_authority()

const ACCEL = 1500.0
const FRICTION = 1200.0

func _physics_process(delta: float) -> void:

	if not is_multiplayer_authority():
		return


	if not is_on_floor():
		velocity.y += gravity * delta


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


	move_and_slide()


	_update_animations(direction)

func _update_animations(direction: float) -> void:
	if not is_on_floor():
		anim.play("jump")

		anim.flip_h = last_direction < 0
	else:
		if direction != 0:
			if direction > 0:
				anim.play("walkright")
				anim.flip_h = false
			else:
				anim.play("walkleft")
				anim.flip_h = false 
		else:
			if last_direction > 0:
				anim.play("idleright")
				anim.flip_h = false
			else:
				anim.play("idleleft")
				anim.flip_h = false
