#tool
#class_name Name #, res://class_name_icon.svg
extends CanvasLayer


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS] 
func _on_Button_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
	var fullscreen_on: String = ""
	var fullscreen_off: String = ""
	match(OS.window_fullscreen):
		true:
			$Button.text = fullscreen_off
		false:
			$Button.text = fullscreen_on
