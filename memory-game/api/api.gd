#tool
#class_name Api #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]
"""This class is an API that receives parameters from the Omeka API."""


#  [SIGNALS]
signal read_url_parameters_completed
signal main_request_completed


#  [ENUMS]


#  [CONSTANTS]
const BASE_URL: String = "https://repositorio.canalciencia.ibict.br/api/items/"
const RESOURCE_MODEL_ID: int = 19


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _game_id: int = 23391 \
		setget set_game_id, get_game_id
		
var _skip_article: bool = false \
		setget set_skip_article, get_skip_article
		
var _resource: Dictionary = {} \
		setget set_resource, get_resource


#  [ONREADY_VARIABLES]
onready var http_request: HTTPRequest = HTTPRequest.new()



#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	connect("read_url_parameters_completed", self, "_on_Api_read_url_parameters_completed")
	
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	
	_read_url_parameters()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_game_id(new_id: int) -> void:
	_game_id = new_id


func get_game_id() -> int:
	return _game_id


func set_skip_article(new_value: bool) -> void:
	_skip_article = new_value


func get_skip_article() -> bool:
	return _skip_article

func set_resource(new_resource: Dictionary) -> void:
	_resource = new_resource


func get_resource() -> Dictionary:
	return _resource


#  [PRIVATE_METHODS]
func _read_url_parameters() -> void:
	# Get URL parameters
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

	# Set ID
	if parameters.has("id"):
		set_game_id(int(parameters["id"]))

	# Set Skip Article
	if parameters.has("skip"):
		match(int(parameters["skip"])):
			0:
				set_skip_article(false)
			1:
				set_skip_article(true)
			_:
				set_skip_article(false)

	emit_signal("read_url_parameters_completed")


#  [SIGNAL_METHODS]
func _on_Api_read_url_parameters_completed() -> void:
	http_request.request(BASE_URL + str(get_game_id()))


func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
#			TYPE_ARRAY:
#				push_error("JSON return Array type. While a dictionary type was expected")
			
			TYPE_DICTIONARY:
				print("Response Code: ", response_code,", JSON return Dictionary type.\n\n")
				
				# Checks if the ID parameter passed by URL is valid.
				if json.result.has("errors"):
					if json.result["errors"].has("error"):
						push_error(str(json.result["errors"]["error"]))
				
				# Checks if the resource model ID matches as expected.
				elif json.result.has("o:resource_template"):
					if json.result["o:resource_template"].has("o:id"):
						if int(json.result["o:resource_template"]["o:id"]) == RESOURCE_MODEL_ID:
							set_resource(json.result)
							emit_signal("main_request_completed")
						else:
							push_error("The resource model ID is valid but does not match as expected.")
							
			_:
				push_error("Unexpected results from JSON response.")
	else:
		push_error(str("response code return error: ", response_code))
