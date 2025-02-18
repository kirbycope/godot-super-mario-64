extends Control

func _ready():
	# Get all TouchScreenButton children
	for button in get_children():
		if button is TouchScreenButton:
			# Connect to pressed and released signals
			button.pressed.connect(_on_button_pressed)
			button.released.connect(_on_button_released)

func _on_button_pressed():
	# Set a global flag that we're interacting with UI
	Input.set_custom_mouse_cursor(null)  # This is a hack to set metadata
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)  # Reset cursor
	
func _on_button_released():
	# Clear the UI interaction flag
	Input.set_custom_mouse_cursor(null)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
