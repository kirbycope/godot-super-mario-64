extends Control


## Called when the node enters the scene tree for the first time.
func _ready():

	# Get all TouchScreenButton children
	for button in get_children():

		# Check if the child is a TouchScreenButton
		if button is TouchScreenButton:

			# Connect to pressed signals
			button.pressed.connect(_on_button_pressed)

			# Connect to released signals
			button.released.connect(_on_button_released)


## Called when a button is _pressed_.
func _on_button_pressed():

	# Set the UI interaction flag
	Input.set_custom_mouse_cursor(null)

	# Set the cursor shape to a pointing hand
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


# Called when a button is _released_.
func _on_button_released():

	# Reset the UI interaction flag
	Input.set_custom_mouse_cursor(null)

	# Set the cursor shape to a pointing hand
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
