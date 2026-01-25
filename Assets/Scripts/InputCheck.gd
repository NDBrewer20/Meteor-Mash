extends Node

var usingController: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		usingController = true
	elif event is InputEventKey:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		usingController = false
	elif event is InputEventMouseMotion and event.relative.length() > 2.0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		usingController = false
