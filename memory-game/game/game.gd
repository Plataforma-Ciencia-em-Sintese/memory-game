#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal add_cards
signal failed_attempt
signal start_timer
signal show_panel_information


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]
#const CardButton := preload("res://game/card_button.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var failed_attempt: int = 0


#  [PRIVATE_VARIABLES]
onready var _card_images: PoolStringArray = [
	"res://game/card/local_images/alma_de_gato.png",
	"res://game/card/local_images/arapaçu_pardo.png", 
	"res://game/card/local_images/araçari_de_pescoço_vermelho.png", 
	"res://game/card/local_images/bico-virado-miúdo.png", 
	"res://game/card/local_images/choquinha_de_flanco_branco.png", 
	"res://game/card/local_images/papa_formiga_barrado.png", 
	"res://game/card/local_images/periquito_testinha.png", 
	"res://game/card/local_images/sai_de_perna_amarela.png", 
	"res://game/card/local_images/surucuá_de_barriga_amarela.png", 
	"res://game/card/local_images/tucano_de_bico_preto.png",
	"res://game/card/local_images/card_11.png",
	"res://game/card/local_images/card_12.png",
]
var _load_card_images: PoolStringArray = []
var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode
var turned_cards: Array = []
var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started
var _timer_counter: int = 0 \
		setget set_timer_counter, get_timer_counter


#  [ONREADY_VARIABLES]
onready var CardButton := preload("res://game/card/card.tscn")
onready var grid := $MarginContainer/AspectRatioContainer/VBoxContainer/GameContainer/MarginContainer/GridContainer
onready var timer_label := $MarginContainer/AspectRatioContainer/VBoxContainer/BarContainer/Time
onready var timer:= $Timer
onready var dev_mode = $DevMode
onready var fullscreen = $MarginContainer/AspectRatioContainer/VBoxContainer/BarContainer/FullScreen
onready var panel_information = $PanelInformation
onready var total_stars = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var total_time = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var total_attempts = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/AttemptsContainer/TotalAttempts


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	connect("add_cards", self, "_on_add_cards")
	connect("failed_attempt", self, "_on_failed_attempt")
	connect("start_timer", self, "_on_start_timer")
	connect("show_panel_information", self, "_on_show_PanelInformation")
	set_current_mode(ChangeLevel.request_mode)
	
	get_tree().get_root().connect("size_changed", self, "_on_window_size_changed")
	_toggle_fullscreen_button_icon()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("dev_mode"):
		dev_mode.visible = !dev_mode.visible


#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_current_mode(mode: int) -> void:
	_current_mode = mode
	
	for child in grid.get_children():
		child.queue_free()
	
	match(mode):
		GameMode.EASY:
			load_card_images()
			_make_grid(get_current_mode())
			show_cards(0.5)

		GameMode.MEDIUM:
			load_card_images()
			_make_grid(get_current_mode())
			show_cards(0.5)
			
		GameMode.HARD:
			load_card_images()
			_make_grid(get_current_mode())
			show_cards(0.5)


func get_current_mode() -> int:
	return _current_mode


func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter


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


func get_random_image() -> String:
	var random_index: int = random_number(0, _load_card_images.size() -1)
#	var result: Texture = load(_load_card_images[random_index])
	var result: String = _load_card_images[random_index]
	_load_card_images.remove(random_index)
	return result


func shuffle_cards() -> void:
	var steps: int = 2
	for _i in range(0, steps):
		for card in grid.get_children():
			var temporary_position: Vector2 = Vector2(0.0, 0.0)
			var ramdom_card := grid.get_child(random_number(0, grid.get_children().size()-1))
			temporary_position = card.get_position()
			card.set_position(ramdom_card.get_position())
			ramdom_card.set_position(temporary_position)
			
			var temporary_index: int = card.get_position_in_parent()
			grid.move_child(card, ramdom_card.get_position_in_parent())
			grid.move_child(ramdom_card, temporary_index)


func show_cards(time: float) -> void:
	yield(get_tree().create_timer(time), "timeout")
	for card in grid.get_children():
		card.to_spin()


#  [PRIVATE_METHODS]
func _make_grid(mode: int):
	var total_cards: int = 0
	var card_size: Vector2 = Vector2.ZERO
	match(mode):
		GameMode.EASY:
			grid.columns = 4
			total_cards = 12
			card_size = Vector2(236, 236)
		GameMode.MEDIUM:
			grid.columns = 5
			total_cards = 20
			card_size = Vector2(188, 188)
		GameMode.HARD:
			grid.columns = 6
			total_cards = 24
			card_size = Vector2(154, 154)
	
# warning-ignore:integer_division
	for _i in range(0, (total_cards/2)): # number of cards divided by 2 insertions
		var texture_path: String = get_random_image() #load("res://cards/papa_formiga_barrado.webp") 
		var texture: Texture = load(texture_path)
		for _j in range(0, 2):
			var card := CardButton.instance()
			grid.add_child(card)
			card.rect_min_size = card_size
			card.set_card_image(texture)
			card.set_card_name(texture_path)
			card.connect("card_turned", self, "_on_card_turned")
			
	emit_signal("add_cards")


func _reset_counters() -> void:
	timer.stop()
	set_timer_has_starded(false)
	set_timer_counter(0)
	yield(get_tree().create_timer(1.0), "timeout") # temporary until set theme template
	timer_label.text = "00:00"
	failed_attempt = 0


func _toggle_fullscreen_button_icon() -> void:
	var fullscreen_on: String = ""
	var fullscreen_off: String = ""
	match(OS.window_fullscreen):
		true:
			fullscreen.text = fullscreen_off
		false:
			fullscreen.text = fullscreen_on


func _update_panel_information() -> void:
	total_stars.bbcode_text = "Você completou o nível!\nConseguiu [color=#aa7bc3][b]0[/b][/color] estrelas."
	total_time.text = timer_label.text
	total_attempts.text = str(failed_attempt)


#  [SIGNAL_METHODS]
func _on_window_size_changed() -> void:
	dev_mode.visible = false
	_toggle_fullscreen_button_icon()


func _on_add_cards() -> void:
	shuffle_cards()


func _on_card_turned(card_instance) -> void:
	emit_signal("start_timer")
	
	if turned_cards.size() == 0:
		turned_cards.append(card_instance)
		return
	if turned_cards.size() == 1:
		for card in grid.get_children():
			card.disabled = true
		yield(get_tree().create_timer(1.0), "timeout")
		if turned_cards[0].get_card_name() == card_instance.get_card_name():
			card_instance.set_current_state(card_instance.State.COMPLETED)
			turned_cards[0].set_current_state(turned_cards[0].State.COMPLETED)
			turned_cards.clear()
		else:
			card_instance.to_spin()
			turned_cards[0].to_spin()
			yield(turned_cards[0], "spin_completed")
			turned_cards.clear()
			emit_signal("failed_attempt")
			
		for card in grid.get_children():
			if card.get_current_state() == card.State.BACK:
				card.disabled = false

	is_full_level()


func _on_start_timer() -> void:
	if not get_timer_has_started():
		set_timer_has_starded(true)
		timer.start()


func _on_failed_attempt() -> void:
	failed_attempt += 1


func is_full_level() -> void:
	var remaining_pairs_counter: int = 0
	
	for card in grid.get_children():
			if not card.get_current_state() == card.State.COMPLETED:
				remaining_pairs_counter += 1
	
	if remaining_pairs_counter == 0:
		yield(get_tree().create_timer(1.0), "timeout")
		emit_signal("show_panel_information")


func _on_Restart_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	_reset_counters()
	if turned_cards.empty():
		for card in grid.get_children():
			card.set_current_state(card.State.FRONT)
			card.disabled = false
		shuffle_cards()
		show_cards(0.5)


func _on_Timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)
	
# warning-ignore:integer_division
# warning-ignore:integer_division
# warning-ignore:integer_division
	timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_DevLevel1_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.EASY)


func _on_DevLevel2_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.MEDIUM)


func _on_DevLevel3_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.HARD)


func _on_FullScreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
	_toggle_fullscreen_button_icon()


func _on_show_PanelInformation() -> void:
	timer.stop()
	_update_panel_information()
	panel_information.visible = true


func _on_PanelInformation_Restart_pressed() -> void:
	panel_information.visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	_reset_counters()
	if turned_cards.empty():
		for card in grid.get_children():
			card.set_current_state(card.State.FRONT)
			card.disabled = false
		shuffle_cards()
		show_cards(0.5)


func _on_PanelInformation_Skip_pressed() -> void:
	_reset_counters()
	
	match(get_current_mode()):
		GameMode.EASY:
			set_current_mode(GameMode.MEDIUM)
		GameMode.MEDIUM:
			set_current_mode(GameMode.HARD)
		GameMode.HARD:
			set_current_mode(GameMode.EASY)
	
	panel_information.visible = false
