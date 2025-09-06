extends CharacterBody2D

var _is_attacking: bool = false
var _state_machine

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 10
@export var _friction: float = 6.5

@export_category("Objects")
@export var _animation_tree: AnimationTree
@export var attack_timer: Timer



func _ready() -> void:
	_animation_tree = $AnimationTree
	_state_machine = _animation_tree.get("parameters/playback")
	attack_timer = $AttackTimer


func _physics_process(delta: float) -> void:
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
	for state in ["idle", "attack"]:
		_animation_tree["parameters/%s/blend_position" % state] = mouse_direction
	   
	if direction_player != Vector2.ZERO:
		_animation_tree["parameters/walk/blend_position"] = direction_player
		
		velocity.x = lerp(velocity.x, direction_player.x * _move_speed, _acceleration * delta)
		velocity.y = lerp(velocity.y, direction_player.y * _move_speed, _acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, direction_player.x * _move_speed, _friction * delta)
		velocity.y = lerp(velocity.y, direction_player.y * _move_speed, _friction * delta)
	
	
func _attack():
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		set_physics_process(false)
		attack_timer.start()
		_is_attacking = true
	
	
		
		
func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
	elif velocity.length() > 8:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")


func _on_attack_timer_timeout() -> void:
	set_physics_process(true)
	_is_attacking = false
