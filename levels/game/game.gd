#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal add_cards


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]
#const CardButton := preload("res://game/card_button.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _card_images: Array = [
	"res://assets/card/local_images/alma_de_gato.png", 
	"res://assets/card/local_images/arapaçu_pardo.png", 
	"res://assets/card/local_images/araçari_de_pescoço_vermelho.png", 
	"res://assets/card/local_images/bico-virado-miúdo.png", 
	"res://assets/card/local_images/choquinha_de_flanco_branco.png", 
	"res://assets/card/local_images/papa_formiga_barrado.png", 
	"res://assets/card/local_images/periquito_testinha.png", 
	"res://assets/card/local_images/sai_de_perna_amarela.png", 
	"res://assets/card/local_images/surucuá_de_barriga_amarela.png", 
	"res://assets/card/local_images/tucano_de_bico_preto.png",
]
var _load_card_images: Array = []
var _current_mode: int = GameMode.HARD \
		setget set_current_mode, get_current_mode


#  [ONREADY_VARIABLES]
onready var grid := $Panel/GridContainer
onready var CardButton := preload("res://assets/card/card.tscn")


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	self.connect("add_cards", self, "_on_add_cards")
	
	load_card_images() #("res://cards/")

	match(get_current_mode()):
		GameMode.EASY:
			_start_easy_mode()
		GameMode.MEDIUM:
			_start_medium_mode()
		GameMode.HARD:
			_start_hard_mode()
	
	# time to spin cards
	yield(get_tree().create_timer(1.0), "timeout")
	for card in grid.get_children():
		card.to_spin()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float)%VOID_RETURN:
#	pass


#  [PUBLIC_METHODS]
func set_current_mode(mode: int) -> void:
	if mode in GameMode:
		_current_mode = mode
	else:
		print("unknown mode.")


func get_current_mode() -> int:
	return _current_mode


func load_card_images() -> void: #path: String) -> void:
#	var dir := Directory.new()
#	if dir.open(path) == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		while file_name != "":
#			if file_name.get_extension() in ["webp"]:
#				if not file_name.get_file() in ["back.webp", "base.webp"]:
#					_card_images.append(path + file_name)
#			file_name = dir.get_next()
#	else:
#		print("An error occurred when trying to access the path.")
	_load_card_images = _card_images


func random_number(start: int, end: int) -> int:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(start, end)


func get_random_image() -> Texture:
	var random_index: int = random_number(0, (_card_images.size() -1))
	var result: Texture = load(_load_card_images[random_index])
	_load_card_images.remove(random_index)
	return result


func shuffle_cards() -> void:
	# to spin positions
	for card in grid.get_children():
		var temporary_position: Vector2 = Vector2(0.0, 0.0)
		var ramdom_card := grid.get_child(random_number(0, grid.get_children().size()-1))
		temporary_position = card.get_position()
		card.set_position(ramdom_card.get_position())
		ramdom_card.set_position(temporary_position)
		
		var temporary_index: int = card.get_position_in_parent()
		grid.move_child(card, ramdom_card.get_position_in_parent())
		grid.move_child(ramdom_card, temporary_index)


#  [PRIVATE_METHODS]
func _start_easy_mode():
	#set colums
	grid.columns = 3
	
	var total_cards: int = 6
# warning-ignore:integer_division
	for _i in range(0, (total_cards/2)): # number of cards divided by 2 insertions
		var texture: Texture = get_random_image() #load("res://cards/papa_formiga_barrado.webp") 
		for _j in range(0, 2):
			var card := CardButton.instance()
			grid.add_child(card)
			card.set_card_image(texture)
	emit_signal("add_cards")
	


func _start_medium_mode():
	#set colums
	grid.columns = 4
	
	var total_cards: int = 12
# warning-ignore:integer_division
	for _i in range(0, (total_cards/2)): # number of cards divided by 2 insertions
		var texture: Texture = get_random_image() #load("res://cards/papa_formiga_barrado.webp") 
		for _j in range(0, 2):
			var card := CardButton.instance()
			grid.add_child(card)
			card.set_card_image(texture)
	emit_signal("add_cards")


func _start_hard_mode():
	#set colums
	grid.columns = 6
	
	var total_cards: int = 18
# warning-ignore:integer_division
	for _i in range(0, (total_cards/2)): # number of cards divided by 2 insertions
		var texture: Texture = get_random_image() #load("res://cards/papa_formiga_barrado.webp") 
		for _j in range(0, 2):
			var card := CardButton.instance()
			grid.add_child(card)
			card.set_card_image(texture)
	emit_signal("add_cards")


#  [SIGNAL_METHODS]
func _on_add_cards() -> void:
	shuffle_cards()
