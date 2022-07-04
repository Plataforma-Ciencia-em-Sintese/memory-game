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

var _back_card: ImageTexture = ImageTexture.new() \
		setget , get_back_card

var _character_panel_information: ImageTexture = ImageTexture.new() \
		setget , get_character_panel_information

var _logo_image: ImageTexture = ImageTexture.new() \
		setget , get_logo_image

var _logo_text: ImageTexture = ImageTexture.new() \
		setget , get_logo_text

var _game_tittle: String = "" \
		setget , get_game_tittle

var _sponsors_logo: ImageTexture = ImageTexture.new() \
		setget , get_sponsors_logo

var _article_summary: String = "" \
		setget , get_article_summary


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	Api.connect("main_request_completed", self, "_on_Api_main_request_completed")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func get_credits() -> String:
	return _credits


func get_cards() -> Array:
	return _cards


func get_back_card() -> ImageTexture:
	return _back_card


func get_character_panel_information() -> ImageTexture:
	return _character_panel_information


func get_logo_image() -> ImageTexture:
	return _logo_image


func get_logo_text() -> ImageTexture:
	return _logo_text


func get_game_tittle() -> String:
	return _game_tittle


func get_sponsors_logo() -> ImageTexture:
	return _sponsors_logo


func get_article_summary() -> String:
	return _article_summary


#  [PRIVATE_METHODS]
func _request_cards() -> void:
	if Api.get_resource().has("game:contains"):
		
		for card in Api.get_resource()["game:contains"]:
			
			var title: String = ""
			if card.has("thumbnail_title"):
				title = str(card["thumbnail_title"]).replace("_", " ").capitalize()
			
			var texture: URLImageTexture = URLImageTexture.new()
			if card.has("thumbnail_url"):
				var http_request: HTTPRequest = HTTPRequest.new()
				add_child(http_request)
				texture.request(URLImageTexture.Type.JPG, http_request, card["thumbnail_url"])
			
			_cards.append({"title": title, "texture": texture})


#  [SIGNAL_METHODS]
func _on_Api_main_request_completed() -> void:
	print("init requests for game_resorces . . .")
	_request_cards()
	print(get_cards())
