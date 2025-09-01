extends CharacterBody2D

var _state_machine

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 10
@export var _friction: float = 6.5

@export_category("Objects")
var _animation_tree: AnimationTree


func _ready() -> void:
	_animation_tree = $AnimationTree
	_state_machine = _animation_tree.get("parameters/playback")


func _physics_process(delta: float) -> void:
	_move(delta)
	_animate()
	move_and_slide()


func _move(delta: float) -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration * delta)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration * delta)
		return
	
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction * delta)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction * delta)
	
	
func _animate() -> void:
	if velocity.length() > 8:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")
