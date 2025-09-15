extends Camera2D
@onready var player: CharacterBody2D = $"../map/Ysort/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = player  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
