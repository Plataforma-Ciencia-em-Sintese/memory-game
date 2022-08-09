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
onready var game_title: Label = $"MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/Tittle"
onready var background_texture := $BackgroundTexture

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	
	game_title.text = GameResources.get_game_tittle().to_upper()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	pass
#	background_texture.set("modulate", ThemeResources.get_color(ThemeResources.PL3))
#	background_texture.set("self_modulate", Color(1.0, 1.0, 1.0, 0.04))
 

#  [SIGNAL_METHODS]


func _on_Easy_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.EASY
	get_tree().change_scene("res://game/game.tscn")


func _on_Medium_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.MEDIUM
	get_tree().change_scene("res://game/game.tscn")


func _on_Hard_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.HARD
	get_tree().change_scene("res://game/game.tscn")


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://credits/credits.tscn")
