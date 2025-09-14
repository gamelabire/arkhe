extends CanvasLayer

@onready var label: Label = $Control/Label
@onready var animation: AnimationPlayer = $Control/Animation

func show_title(subtitle: String, main_title = "Arkhe"):
	label.text = main_title
	label.get_node("SubTitle").text = subtitle
	animation.play("Fadein")

# func _process(_delta: float) -> void:
# 	if Input.is_action_just_pressed("ui_text_submit"):
# 		show_title("Explore o sertão em busca do poço secreto")
