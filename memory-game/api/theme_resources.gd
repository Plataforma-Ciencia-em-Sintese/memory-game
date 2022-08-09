#tool
#class_name Name #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]
signal theme_color_request_completed


#  [ENUMS]
# PL3, PL2, PL1, PB,  PD1, PD2, PD3 (PRIMARY-LIGHT, PRIMARY-BASE, PRIMARY-DARK)
enum {PL3, PL2, PL1, PB,  PD1, PD2, PD3}
# SL3, SL2, SL1, SB,  SD1, SD2, SD3 (SECONDARY-LIGHT, SECONDARY-BASE, SECONDARY-DARK)
enum {SL3, SL2, SL1, SB,  SD1, SD2, SD3}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var test_mode: bool = true
var test_primary: String = "#9A63B8"
var test_secondary: String = "#B8D54D"


#  [PRIVATE_VARIABLES]
var _resource: Dictionary = {} \
		setget set_resource, get_resource

var _primary_color: Color = Color() \
		setget set_primary_color, get_primary_color

var _secondary_color: Color = Color() \
		setget set_secondary_color, get_secondary_color


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
func _init() -> void:
	Api.connect("main_request_completed", self, "_on_Api_main_request_completed")


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	if test_mode:
		set_primary_color(test_primary)
		set_secondary_color(test_secondary)


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_resource(new_resource: Dictionary) -> void:
	_resource = new_resource


func get_resource() -> Dictionary:
	return _resource


func set_primary_color(new_value: Color) -> void:
	if test_mode:
		_primary_color = Color(test_primary)
	else:
		_primary_color = new_value


func get_primary_color() -> Color:
	return _primary_color


func set_secondary_color(new_value: Color) -> void:
	if test_mode:
		_secondary_color = Color(test_secondary)
	else:
		_secondary_color = new_value


func get_secondary_color() -> Color:
	return _secondary_color


func get_color(name: int) -> Color:
	var color: Color = Color()
	var intensity: float = 0.25
	
	match(name):
		# PRIMARY COLORS
		PL3:
			color = get_primary_color().lightened(intensity * 3.0)
		PL2:
			color = get_primary_color().lightened(intensity * 2.0)
		PL1:
			color = get_primary_color().lightened(intensity)
		PB:
			color = get_primary_color()
		PD1: 
			color = get_primary_color().darkened(intensity)
		PD2: 
			color = get_primary_color().darkened(intensity * 2.0)
		PD3:
			color = get_primary_color().darkened(intensity * 3.0)

		# SECONDARY COLORS
		SL3: 
			color = get_secondary_color().lightened(intensity * 3.0)
		SL2: 
			color = get_secondary_color().lightened(intensity * 2.0)
		SL1: 
			color = get_secondary_color().lightened(intensity)
		SB:  
			color = get_secondary_color()
		SD1:
			color = get_secondary_color().darkened(intensity)
		SD2: 
			color = get_secondary_color().darkened(intensity * 2.0)
		SD3:
			color = get_secondary_color().darkened(intensity * 3.0)

	return color


#  [PRIVATE_METHODS]
func _request_main() -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	
	var url: String = ""
	var ssl_validate_domain: bool = true if OS.get_name() == "HTML5" else false
	
	if Api.get_resource().has("game:belongsTo"):
		if Api.get_resource()["game:belongsTo"][0].has("@id"):
			url = str(Api.get_resource()["game:belongsTo"][0]["@id"])
	
	var error: int = http_request.request(url, PoolStringArray(), ssl_validate_domain)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

#  [SIGNAL_METHODS]
func _on_Api_main_request_completed() -> void:
	_request_main()


func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
#			TYPE_ARRAY:
#				push_error("JSON return Array type. While a dictionary type was expected")
			
			TYPE_DICTIONARY:
				#print("Response Code: ", response_code,", JSON return Dictionary type.\n\n")
				
				# Checks if the ID parameter passed by URL is valid.
				if json.result.has("errors"):
					if json.result["errors"].has("error"):
						push_error(str(json.result["errors"]["error"]))
				
				elif json.result.has("bibframe:colorContent"):
					if json.result["bibframe:colorContent"][0].has("@value"):
						set_primary_color(Color(str(json.result["bibframe:colorContent"][0]["@value"])))
					if json.result["bibframe:colorContent"][1].has("@value"):
						set_secondary_color(Color(str(json.result["bibframe:colorContent"][1]["@value"])))
					
					emit_signal("theme_color_request_completed")
			_:
				push_error("Unexpected results from JSON response.")
	else:
		push_error(str("response code return error: ", response_code))
