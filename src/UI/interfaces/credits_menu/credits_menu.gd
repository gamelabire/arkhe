extends Node2D

@onready var goBackLabel: Label = $CanvasLayer/goBack

func _ready() -> void:
	goBackLabel.connect("gui_input", Callable(self, "_on_credits_gui_input"))

func _tween_label_color(label: Label, to_color: Color):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", to_color, 0.2)

func _on_go_back_mouse_entered():
	_tween_label_color(goBackLabel, Color(1, 1, 0.6))
	
func _on_go_back_mouse_exited():
	_tween_label_color(goBackLabel, Color(1, 1, 1))

func _on_credits_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://src/UI/interfaces/main_menu/main_menu.tscn")
