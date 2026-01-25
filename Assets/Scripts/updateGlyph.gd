extends Label

@export var input: InputEventAction
var startString: String

func _ready() -> void:
	startString = text

func _process(delta: float) -> void:
	if InputCheck.usingController:
		text = startString.replace("%",GlyphDict.CON_Glyphs[input.action])
	else:
		text = startString.replace("%",GlyphDict.KBM_Glyphs[input.action])
