#tool
#class_name Name #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]
# Omeka Server


#  [SIGNALS]
signal api_request_completed


#  [ENUMS]


#  [CONSTANTS]
const BASE_URL: String = "https://repositorio.canalciencia.ibict.br/api/items/"
const RESOURCE_MODEL_ID: int = 19


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _url_parameters: Dictionary = {} \
		setget set_url_parameters, get_url_parameters
var _skip_article: bool = false \
		setget set_skip_article, get_skip_article


#  [ONREADY_VARIABLES]
onready var http_request: HTTPRequest = HTTPRequest.new()


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	set_url_parameters(_javascript_url_access_parameters())
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	request()

#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func request() -> void:
	var parameters: Dictionary = get_url_parameters()
	
	if parameters.has("id"):
		var http_error = http_request.request(BASE_URL + str(parameters["id"]))
		if http_error != OK:
			push_warning("An error occurred in the HTTP request.")


func set_url_parameters(new_url_parameters: Dictionary) -> void:
	_url_parameters = new_url_parameters
	
	if _url_parameters.has("skip"):
		print(int(_url_parameters["skip"]))
		match(int(_url_parameters["skip"])):
			1:
				set_skip_article(true)
			0:
				set_skip_article(false)


func get_url_parameters() -> Dictionary:
	return _url_parameters


func set_skip_article(new_value: bool) -> void:
	_skip_article = new_value


func get_skip_article() -> bool:
	return _skip_article


#  [PRIVATE_METHODS]
func _javascript_url_access_parameters() -> Dictionary:
	"""
	expected pattern for url parameters
	---
	single parameter
	?parameter=value 
	
	multiple parameters
	?parameter1=value&parameter2=value
	"""
	
	
	# The Javascript Class only works for HTML5
	var raw_string: String = str(JavaScript.eval("location.search.split('?')[1];"))
	#For testing in native execution, simulating url parameters.
	#raw_string = "id=23391&trash=000&skip=1"
	
	var strings: PoolStringArray = raw_string.split("&")
	
	var parameters: Dictionary = {}
	for item in strings:
		match(item.split("=")[0]):
			"id":
				parameters[item.split("=")[0]] = item.split("=")[1]
			"skip":
				parameters[item.split("=")[0]] = item.split("=")[1]
			_:
				pass
	
	return parameters
 

#  [SIGNAL_METHODS]
func _on_request_completed(_result, response_code, _headers, body):

	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		
		match(typeof(json.result)):
			TYPE_ARRAY:
				push_error("JSON return Array type. While a dictionary type was expected")
			
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
							emit_signal("api_request_completed")
						else:
							push_error("The resource model ID is valid but does not match as expected.")
					
			
			_:
				push_error("Unexpected results from JSON response.")
	else:
		push_error(response_code)
		
