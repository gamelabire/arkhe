extends Node2D


@onready var animation: AnimationPlayer = $Animation
@onready var main_player: CharacterBody2D = $map/Ysort/Player
@onready var cutscene_player: CharacterBody2D = $map/Opening_Cutscene/CutScenePlayer
@onready var level_title: CanvasLayer = $map/Opening_Cutscene/Level_Title

func _ready() -> void:
	main_player.camera.enabled = false
	main_player.set_physics_process(false)
	main_player.visible = false
	
	cutscene_player.is_in_cutscene = true
	
	animation.play("opening_cutscene")
	await animation.animation_finished
	
	main_player.position = cutscene_player.position
	main_player.camera.enabled = true
	main_player.set_physics_process(true)
	main_player.visible = true
	
	cutscene_player.queue_free()
	level_title.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		animation.stop()
		main_player.play_anim("idle", Vector2(0, 1))
		main_player.camera.enabled = true
		main_player.set_physics_process(true)
		main_player.visible = true
		cutscene_player.queue_free()
		level_title.queue_free()
