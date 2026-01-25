extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	GameController.player.dashLookDir = toggled_on
