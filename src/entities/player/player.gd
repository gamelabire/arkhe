extends CharacterBody2D

@export_category("Variables")
@export var MOVE_SPEED: float = 64.0
@export var ACCELERATION: float = 10
@export var FRICTION: float = 6.5

@export var DASH_SPEED: float = 180.0
@export var DASH_DURATION: float = 0.25
@export var DASH_COOLDOWN: float = 0.6

var is_in_cutscene: bool = false
var _is_attacking: bool = false
var _is_dashing: bool = false
var _can_dashing: bool = true

var _state_machine


@export_category("Objects")
@export var _animation_tree: AnimationTree
@export var camera: Camera2D

@export var dash_timer: Timer
@export var dash_countdown_timer: Timer

@export_category("Camera")
@export var limit_camera_top = -10000000
@export var limit_camera_bottom = 10000000
@export var limit_camera_right = 10000000
@export var limit_camera_left = -10000000


func _ready() -> void:
	_animation_tree = $AnimationTree
	_state_machine = _animation_tree.get("parameters/playback")
	
	dash_timer = $timers/dash/backDashTimer
	dash_countdown_timer = $timers/dash/backDashCountdown
	
	# changing the limits of the player's camera as far as he can see on the map
	camera = $Camera2D
	camera.limit_top = limit_camera_top
	camera.limit_bottom = limit_camera_bottom
	camera.limit_right = limit_camera_right
	camera.limit_left = limit_camera_left

func _physics_process(delta: float) -> void:
	if is_in_cutscene:
		move_and_slide()
		return
		
	_start_dash()
	
	if not _is_dashing:
		_move(delta)
		_attack()
	
	_animate()
	move_and_slide()

func _move(delta: float) -> void:
	var direction_player := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	var mouse_direction := (get_global_mouse_position() - global_position).normalized()
	
	# Update blend positions
	for state in ["idle", "back_dash"]:
		_animation_tree["parameters/%s/blend_position" % state] = mouse_direction
	   
	if direction_player != Vector2.ZERO:
		_animation_tree["parameters/walk/blend_position"] = direction_player
		
		velocity.x = lerp(velocity.x, direction_player.x * MOVE_SPEED, ACCELERATION * delta)
		velocity.y = lerp(velocity.y, direction_player.y * MOVE_SPEED, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, direction_player.x * MOVE_SPEED, FRICTION * delta)
		velocity.y = lerp(velocity.y, direction_player.y * MOVE_SPEED, FRICTION * delta)

func _attack():
	# if Input.is_action_just_pressed("attack") and not _is_attacking:
	# 	set_physics_process(false)
	# 	_is_attacking = true
	pass

func _start_dash():
	if Input.is_action_just_pressed("back_dash") and not _is_dashing and _can_dashing:
		_is_dashing = true
		_can_dashing = false
		dash_timer.start(DASH_DURATION)
		
		var dash_direction = (global_position - get_global_mouse_position()).normalized()
		velocity = dash_direction * DASH_SPEED

func _animate() -> void:
	if _is_dashing:
		_state_machine.travel("back_dash")
	elif _is_attacking:
		_state_machine.travel("attack")
	elif velocity.length() > 8:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")

func play_anim(state: String, direction: Vector2):
	_animation_tree["parameters/%s/blend_position" % state] = direction
	_state_machine.travel(state)

func _on_back_dash_timer_timeout() -> void:
	_is_dashing = false
	dash_countdown_timer.start(DASH_COOLDOWN)

func _on_back_dash_countdown_timeout() -> void:
	_can_dashing = true
