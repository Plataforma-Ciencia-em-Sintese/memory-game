#tool
class_name URLParameters #, res://class_name_icon.svg
#extends Node


#  [DOCSTRING]
"""This class takes parameters passed by URL"""

"""Expected pattern for url parameters

single parameter
	?parameter=value 

multiple parameters
	?parameter1=value&parameter2=value
"""


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _parameters: Dictionary = {} \
		setget , get_parameters


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
func get_parameters() -> Dictionary:
	var raw_string: String = ""
	if str(OS.get_name()) == "HTML5":
		# The Javascript Class only works for HTML5.
		raw_string = str(JavaScript.eval("location.search.split('?')[1];"))
	else:
		# For testing in environments other than HTML5.
		var fake_url_parameters: String = "id=23391&trash=000&skip=1"
		raw_string = fake_url_parameters
	
	var strings: PoolStringArray = raw_string.split("&")
	
	var parameters: Dictionary = {}
	for item in strings:
		parameters[item.split("=")[0]] = item.split("=")[1]
	
	return parameters


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]
