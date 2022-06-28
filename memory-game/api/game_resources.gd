#tool
#class_name Name #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]
"""This class makes the game resources available"""

"""Resources per scene

credits scene
	get_credits: String

game scene
	get_cards: Array
	get_back_card: Texture
	get_character_panel_information: Texture 

home scene
	get_logo_image: Texture
	get_logo_text: Texture
	get_game_tittle: String

opening scene
	get_sponsors_logo: Texture

resume scene
	get_article_summary: String
"""


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _credits: String = "" \
		setget , get_credits

var _cards: Array = [] \
		setget , get_cards

var _back_card: Texture = null \
		setget , get_back_card

var _character_panel_information: Texture = null \
		setget , get_character_panel_information

var _logo_image: Texture = null \
		setget , get_logo_image

var _logo_text: Texture = null \
		setget , get_logo_text

var _game_tittle: String = "" \
		setget , get_game_tittle

var _sponsors_logo: Texture = null \
		setget , get_sponsors_logo

var _article_summary: String = "" \
		setget , get_article_summary


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
func get_credits() -> String:
	return _credits


func get_cards() -> Array:
	return _cards


func get_back_card() -> Texture:
	return _back_card


func get_character_panel_information() -> Texture:
	return _character_panel_information


func get_logo_image() -> Texture:
	return _logo_image


func get_logo_text() -> Texture:
	return _logo_text


func get_game_tittle() -> String:
	return _game_tittle


func get_sponsors_logo() -> Texture:
	return _sponsors_logo


func get_article_summary() -> String:
	return _article_summary


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
