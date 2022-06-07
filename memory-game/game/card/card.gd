#tool
#class_name Name #, res://class_name_icon.svg
extends TextureButton


#  [DOCSTRING]


#  [SIGNALS]
signal card_turned(card)
signal spin_completed


#  [ENUMS]
enum State {FRONT, BACK, COMPLETED}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES] 
var _card_front_image: Texture = null
var _card_back_image: Texture = null
var _current_state: int = State.FRONT \
		setget set_current_state, get_current_state
var _card_name: String = "" \
		setget set_card_name, get_card_name


#  [ONREADY_VARIABLES]
onready var label := $Label
onready var tween := $Tween


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init(image: Texture) -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_card_front_image = load("res://game/card/local_images/periquito_testinha.png")
	_card_back_image = load("res://game/card/back_card.png")
	texture_normal = _card_front_image


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float)%VOID_RETURN:
#	pass


#  [PUBLIC_METHODS]
func set_current_state(state: int) -> void:
	_current_state = state
	
	match(_current_state):
		State.FRONT:
			set_card_image(_card_front_image)
			self_modulate = Color(1.0, 1.0, 1.0, 1.0) 
		State.BACK:
			label.visible = false
			set_card_image(_card_back_image)
			self_modulate = Color(1.0, 1.0, 1.0, 1.0) 
		State.COMPLETED:
			disabled = true
			label.visible = true
			self_modulate = Color(0.65, 0.65, 0.65, 1.0) 


func get_current_state() -> int:
	return _current_state


func get_current_image() -> Texture:
	return texture_normal


func set_card_image(image: Texture) -> void:
	self.texture_normal = image
	
	if not image == _card_back_image:
		_card_front_image = image


func set_card_name(new_name: String) -> void:
	new_name = new_name.replace("res://game/card/local_images/", "")
	new_name = new_name.replace(".png", "")
	new_name = new_name.replace("_", " ")
	_card_name = new_name
	label.text = new_name.capitalize()


func get_card_name() -> String:
	return _card_name


func to_spin() -> void:
	var temporary_scale_x: float = get_scale().x
	var state: int = get_current_state()
	
	rect_pivot_offset = Vector2(rect_size.x/2, rect_size.x/2)
	
	tween.interpolate_property(self, "rect_scale:x", temporary_scale_x, 0.0, 0.1,
			Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	match(get_current_state()):
		State.FRONT:
			set_current_state(State.BACK)
		State.BACK:
			set_current_state(State.FRONT)
	
	tween.interpolate_property(self, "rect_scale:x", 0.0, temporary_scale_x, 0.1,
			Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	emit_signal("spin_completed")


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_CardButton_pressed() -> void:
	disabled = true
	to_spin()
	emit_signal("card_turned", self)


func _on_CardButton_mouse_entered() -> void:
#	if get_current_state() == State.FRONT:
#		label.visible = true
	pass

func _on_CardButton_mouse_exited() -> void:
	if get_current_state() == State.FRONT:
		label.visible = false
