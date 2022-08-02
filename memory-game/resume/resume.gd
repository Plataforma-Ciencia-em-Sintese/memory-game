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
onready var article_summary: Label = $"MarginContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/Text"
onready var background_texture := $BackgroundTexture

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	
	article_summary.text = GameResources.get_article_summary() + "\n\n Bom Divertimento!"


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	background_texture.set("modulate", ThemeResources.get_color(ThemeResources.PL3))
	background_texture.set("self_modulate", Color(1.0, 1.0, 1.0, 0.04))
 

#  [SIGNAL_METHODS]
func _on_Redirect_pressed() -> void:
	var url: String = "https://www.canalciencia.ibict.br/ciencia-em-sintese1/ciencias-biologicas/196-por-que-existe-tanta-diversidade-de-aves-nas-florestas-tropicais"
	OS.shell_open(url)


func _on_Skip_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://credits/credits.tscn")
