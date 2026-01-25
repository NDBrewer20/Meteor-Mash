extends Node

@export var sceneToLoad: PackedScene
@export var input: InputEventAction

func _ready() -> void:
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released(input.action):
		if sceneToLoad:
			get_tree().change_scene_to_packed(sceneToLoad)
		else:
			get_tree().quit()
