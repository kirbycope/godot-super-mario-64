extends TextureRect

const HAND_CLOSED = preload("res://assets/hand_closed.png")
const HAND_OPENED = preload("res://assets/hand_opened.png")

func _ready() -> void:
	# Set up input handling
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Ensure the node can process input
	set_process_input(true)
	# Set initial texture
	texture = HAND_OPENED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Update position using local coordinates
		position = event.position
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			texture = HAND_CLOSED if event.pressed else HAND_OPENED

# Optional: Add this if you need smooth updates between input events
func _process(_delta: float) -> void:
	# Update position every frame for smoother movement
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos != position:
		position = mouse_pos
