extends Node

var canvas: CanvasLayer

func _ready() -> void:
	canvas = get_child(0)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_menu"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			canvas.show()
		else:
			canvas.hide()
		


func _on_resume_button_up() -> void:
	get_tree().paused = false
	canvas.hide()


func _on_quit_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Splash.tscn")
