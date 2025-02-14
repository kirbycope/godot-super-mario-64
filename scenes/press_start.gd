extends TextureRect

@export var toggle_interval: float = 1.0

func _ready():
	start_toggle()

func start_toggle():
	var timer = Timer.new()
	timer.wait_time = toggle_interval
	timer.autostart = true
	timer.timeout.connect(toggle_visibility)
	add_child(timer)

func toggle_visibility():
	visible = !visible
