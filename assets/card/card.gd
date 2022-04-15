#tool
#class_name Name #, res://class_name_icon.svg
extends AspectRatioContainer


#  [DOCSTRING]


#  [SIGNALS]
signal card_turned(state, image)


#  [ENUMS]
enum State {FRONT, BACK}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES] 
var _card_front_image: Texture = null
var _card_back_image: Texture = null
var _current_state: int = State.FRONT \
		setget set_current_state, get_current_state


#  [ONREADY_VARIABLES]
onready var button := $TextureButton
onready var tween := $Tween


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init(image: Texture) -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	var image: Texture = load("res://assets/card/local_images/alma_de_gato.png")
	set_card_image(image)
	_card_front_image = image
	_card_back_image = load("res://assets/card/back_card.png")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float)%VOID_RETURN:
#	pass


#  [PUBLIC_METHODS]
func set_current_state(state: int) -> void:
	_current_state = state


func get_current_state() -> int:
	return _current_state


func get_current_image() -> Texture:
	return button.texture_normal


func set_card_image(image: Texture) -> void:
	button.texture_normal = image
	
	if not image == _card_back_image:
		_card_front_image = image 


func to_spin() -> void:
	var temporary_scale_x: float = button.get_scale().x
	
	button.rect_pivot_offset = Vector2(button.rect_size.x/2, button.rect_size.x/2)
	button.disabled = true
	
	tween.interpolate_property(button, "rect_scale:x", temporary_scale_x, 0.0, 0.18,
			Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	match(get_current_state()):
		State.FRONT:
			set_card_image(_card_back_image)
			set_current_state(State.BACK)
		State.BACK:
			set_card_image(_card_front_image)
			set_current_state(State.FRONT)
	
	tween.interpolate_property(button, "rect_scale:x", 0.0, temporary_scale_x, 0.18,
			Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	button.disabled = false


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]


func _on_TextureButton_pressed() -> void:
	to_spin()
	emit_signal("card_turned", get_current_state(), get_current_image())
