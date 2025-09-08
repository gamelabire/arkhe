extends Control

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	return

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("text"):
		animation_player.play("Fadein")
		
	return
