extends CharacterBody2D
class_name Scorpion

var _player_ref = null

@export_category("Variables")
@export var _texture: Sprite2D
@export var _animation: AnimationPlayer

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_ref = null

func _physics_process(delta: float) -> void:
	_animate()
	if _player_ref != null:
		var _direction: Vector2 = global_position.direction_to(_player_ref.global_position)
		velocity = _direction * 40
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _animate() -> void:
	if velocity.x > 0:
		_texture.flip_h = false
	if velocity.x < 0:
		_texture.flip_h = true
	
	if velocity != Vector2.ZERO:
		_animation.play("walk")
		return
		
	_animation.play("idle")
