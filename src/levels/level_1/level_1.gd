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
	
	cutscene_player.camera.position_smoothing_enabled = false
	
	animation.play("opening_cutscene")
	await animation.animation_finished
	
	animation.play("Tutorial")
	main_player.global_position = cutscene_player.global_position
	main_player.play_anim("idle", Vector2(0, 1))
	
	main_player.camera.enabled = true
	main_player.set_physics_process(true)
	main_player.visible = true
	
	cutscene_player.queue_free()
	level_title.queue_free()
