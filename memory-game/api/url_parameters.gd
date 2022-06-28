#tool
class_name URLParameters #, res://class_name_icon.svg
#extends Node


#  [DOCSTRING]
"""This class takes parameters passed by URL."""


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _parameters: Dictionary = {} \
		setget set_parameters, get_parameters


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
func _init() -> void:
	_url_access_parameters()


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_parameters(new_parameters: Dictionary) -> void:
	_parameters = new_parameters


func get_parameters() -> Dictionary:
	return _parameters


#  [PRIVATE_METHODS]
func _url_access_parameters() -> void:
	"""
	expected pattern for url parameters
	---
	single parameter
	?parameter=value 
	
	multiple parameters
	?parameter1=value&parameter2=value
	"""
	
	var raw_string: String = ""
	if str(OS.get_name()) == "HTML5":
		# The Javascript Class only works for HTML5.
		raw_string = str(JavaScript.eval("location.search.split('?')[1];"))
	else:
		# For testing in environments other than HTML5.
		var fake_url_parameters: String = "id=23391&trash=000&skip=1"
		raw_string = fake_url_parameters
	
	#print(raw_string)
	
	var strings: PoolStringArray = raw_string.split("&")
	
	var parameters: Dictionary = {}
	for item in strings:
		parameters[item.split("=")[0]] = item.split("=")[1]
	
	
	#print(parameters)
	
	set_parameters(parameters)
 

#  [SIGNAL_METHODS]
