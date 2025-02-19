extends TextureRect

const HAND_CLOSED = preload("res://assets/hand_closed.png")
const HAND_OPENED = preload("res://assets/hand_opened.png")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Set up input handling
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Ensure the node can process input
	set_process_input(true)

	# Set initial texture
	texture = HAND_OPENED


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event: InputEvent) -> void:

	# Check if the event is a mouse motion event
	if event is InputEventMouseMotion:

		# Update position using local coordinates
		position = event.position
	
	# Check if the event is a mouse button event
	elif event is InputEventMouseButton:

		# Check if the left mouse button was pressed
		if event.button_index == MOUSE_BUTTON_LEFT:

			# Update texture based on button state
			texture = HAND_CLOSED if event.pressed else HAND_OPENED


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Get the current mouse position
	var mouse_pos = get_viewport().get_mouse_position()

	# Check if the mouse position has changed
	if mouse_pos != position:

		# Update the position of the cursor
		position = mouse_pos
