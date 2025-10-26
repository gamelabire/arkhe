extends Node2D

@onready var startLabel = $CanvasLayer/Control/VBoxContainer/start
@onready var creditsLabel = $CanvasLayer/Control/VBoxContainer/credits
@onready var exitLabel = $CanvasLayer/Control/VBoxContainer/exit

func _ready():
	startLabel.mouse_filter = Control.MOUSE_FILTER_STOP
	creditsLabel.mouse_filter = Control.MOUSE_FILTER_STOP
	exitLabel.mouse_filter = Control.MOUSE_FILTER_STOP

	startLabel.connect("gui_input", Callable(self, "_on_start_gui_input"))
	creditsLabel.connect("gui_input", Callable(self, "_on_credits_gui_input"))
	exitLabel.connect("gui_input", Callable(self, "_on_exit_gui_input"))

func _tween_label_color(label: Label, to_color: Color):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", to_color, 0.2)

# START
func _on_start_mouse_entered():
	_tween_label_color(startLabel, Color(1, 1, 0.6))
	
func _on_start_mouse_exited():
	_tween_label_color(startLabel, Color(1, 1, 1))

# CREDITS
func _on_credits_mouse_entered():
	_tween_label_color(creditsLabel, Color(1, 1, 0.6))
	
func _on_credits_mouse_exited():
	_tween_label_color(creditsLabel, Color(1, 1, 1))

# EXIT
func _on_exit_mouse_entered():
	_tween_label_color(exitLabel, Color(1, 1, 0.6))

func _on_exit_mouse_exited():
	_tween_label_color(exitLabel, Color(1, 1, 1))


# ================= Click =================
func _on_start_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://src/levels/level_1/level_1.tscn")

func _on_credits_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://src/UI/interfaces/credits_menu/credits_menu.tscn")

func _on_exit_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().quit()
