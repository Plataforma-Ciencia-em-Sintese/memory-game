#tool
class_name  URLImageTexture #, res://class_name_icon.svg
extends ImageTexture


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
enum Type {JPG, JPEG, PNG, WEBP, BMP, TGA}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]



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
func request(image_type: int, http_request: HTTPRequest, url: String) -> void:
	http_request.connect("request_completed", self, "_on_HTTPRequest_request_completed", [image_type])
	
	var custom_headers: PoolStringArray = PoolStringArray()
	var ssl_validate_domain: bool = false
	var request_data: String = String()
	
	var error: int = http_request.request(url, custom_headers, ssl_validate_domain, HTTPClient.METHOD_GET, request_data)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, image_type: int) -> void:
	if response_code == 200:
		var image: Image = Image.new()
		
		var error: int = OK
		match(image_type): # {JPG, JPEG, PNG, WEBP, BMP, TGA}
			Type.JPG:
				error = image.load_jpg_from_buffer(body)
			Type.JPEG:
				error = image.load_jpg_from_buffer(body)
			Type.PNG:
				error = image.load_png_from_buffer(body)
			Type.WEBP:
				error = image.load_webp_from_buffer(body)
			Type.BMP:
				error = image.load_bmp_from_buffer(body)
			Type.TGA:
				error = image.load_tga_from_buffer(body)
		if error != OK:
			push_error("There was an error creating the image.")
		
		create_from_image(image)
