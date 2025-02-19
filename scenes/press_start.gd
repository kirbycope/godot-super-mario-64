extends TextureRect

@export var toggle_interval: float = 1.0


## Start the toggle timer.
func start_toggle():

	# Create a timer
	var timer = Timer.new()

	# Set the timer wait time
	timer.wait_time = toggle_interval

	# Start the timer
	timer.autostart = true

	# Connect the timer timeout signal
	timer.timeout.connect(toggle_visibility)

	# Add the timer as a child
	add_child(timer)


## Toggle the visibility of the node.
func toggle_visibility():

	# Toggle the visibility
	visible = !visible
