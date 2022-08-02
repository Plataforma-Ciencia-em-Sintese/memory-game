#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var animation := $AnimationPlayer
onready var background_texture := $BackgroundTexture


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	
	animation.play("fade")
	yield(animation, "animation_finished")
	
	if Api.get_skip_article():
		get_tree().change_scene("res://home/home.tscn")
	else:
		get_tree().change_scene("res://resume/resume.tscn")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	background_texture.set("modulate", ThemeResources.get_color(ThemeResources.PL3))
	background_texture.set("self_modulate", Color(1.0, 1.0, 1.0, 0.04))

#  [SIGNAL_METHODS]
