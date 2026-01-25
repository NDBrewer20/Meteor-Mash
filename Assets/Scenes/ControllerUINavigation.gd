extends CanvasLayer

func _process(delta: float) -> void:
	if visible:
		$CenterContainer/GridContainer/Resume.grab_focus()
