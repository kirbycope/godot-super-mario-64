extends Node3D

const COIN = preload("res://assets/coin.wav")
const HELLO = preload("res://assets/hello.wav")
const ITS_A_ME_MARIO = preload("res://assets/its_a_me_mario.wav")
const TITLE_THEME = preload("res://assets/title_theme.ogg")

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player_3d: AudioStreamPlayer3D = $MarioHead/AudioStreamPlayer3D
@onready var animation_player = $MarioHead/AnimationPlayer
@onready var background = $Background
@onready var buttons: Control = $Camera3D/CanvasLayer/Buttons
@onready var cursor = $Camera3D/CanvasLayer/Cursor
@onready var keyboard_controls: RichTextLabel = $Camera3D/CanvasLayer/KeyboardControls
@onready var logo = $Logo/logo
@onready var logo_1996 = $"1996"
@onready var logo_tm = $TM
@onready var mario_head = $MarioHead
@onready var press_start = $Camera3D/CanvasLayer/PressStart
@onready var transition = $Camera3D/CanvasLayer/Transition
@onready var touch_controls: RichTextLabel = $Camera3D/CanvasLayer/TouchControls

var show_controls: bool = false


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event: InputEvent) -> void:

	# Check if show controls is enabled
	if show_controls:

		# Check if the event is a screen drag or touch event
		if event is InputEventScreenDrag or event is InputEventScreenTouch:

			# Show the touch controls
			buttons.visible = true
			touch_controls.visible = true

			# Hide the keyboard and mouse controls
			cursor.visible = false
			keyboard_controls.visible = false

		# The event is not a screen drag or touch event
		else:

			# Hide the touch controls
			buttons.visible = false
			touch_controls.visible = false

			# Show the keyboard and mouse controls
			cursor.visible = true
			keyboard_controls.visible = true


## Called when the node enters the scene tree for the first time.
func _ready():
	for button in $Camera3D/CanvasLayer/Buttons.get_children():
		if button is TouchScreenButton:
			button.add_to_group("touch_buttons")
	background.visible = false
	buttons.visible = false
	cursor.visible = false
	keyboard_controls.visible = false
	logo.visible = true
	logo.scale = Vector3.ZERO
	logo_1996.visible = false
	logo_tm.visible = false
	mario_head.visible = false
	press_start.visible = false
	touch_controls.visible = false
	start_sequence()


## Runs the "start" sequence.
func start_sequence():
	audio_player.stream = COIN
	audio_player.play()
	var tween = create_tween()
	tween.tween_property(logo, "scale", Vector3.ONE, 1.0)
	tween.tween_callback(func():
		audio_player_3d.stream = ITS_A_ME_MARIO
		audio_player_3d.play()
	)
	tween.tween_property(logo, "scale", Vector3(1.1, 1.1, 1.1), 0.15)
	tween.tween_property(logo, "scale", Vector3(0.9, 0.9, 0.9), 0.15)
	tween.tween_property(logo, "scale", Vector3(1.05, 1.05, 1.05), 0.15)
	tween.tween_property(logo, "scale", Vector3(0.95, 0.95, 0.95), 0.15)
	tween.tween_property(logo, "scale", Vector3.ONE, 0.15)
	tween.tween_callback(func():
		logo_1996.visible = true
		logo_tm.visible = true
	)
	tween.tween_interval(2.0)
	tween.tween_callback(func():
		logo_1996.visible = false
		logo_tm.visible = false
	)
	tween.tween_property(logo, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(func():
		background.visible = true
		mario_head.visible = true
		transition.visible = true
		transition.start_transition()
	)
	tween.tween_interval(1.0)
	tween.tween_callback(func():
		cursor.visible = true
		press_start.visible = true
		press_start.start_toggle()
		animation_player.play("hello")
		audio_player.stream = TITLE_THEME
		audio_player.play()
		audio_player_3d.stream = HELLO
		audio_player_3d.play()
		show_controls = true
	)


## [b] button is _pressed_.
func _on_button_b_pressed() -> void:
	mario_head.switch_zoom_level()


## [c-down] button is _pressed_.
func _on_button_c_down_pressed() -> void:
	Input.action_press("rotate_down")


## [c-down] button is _released_.
func _on_button_c_down_released() -> void:
	Input.action_release("rotate_down")


## [c-left] button is _pressed_.
func _on_button_c_left_pressed() -> void:
	Input.action_press("rotate_left")


## [c-left] button is _released_.
func _on_button_c_left_released() -> void:
	Input.action_release("rotate_left")


## [c-right] button is _pressed_.
func _on_button_c_right_pressed() -> void:
	Input.action_press("rotate_right")


## [c-right] button is _released_.
func _on_button_c_right_released() -> void:
	Input.action_release("rotate_right")


## [c-up] button is _pressed_.
func _on_button_c_up_pressed() -> void:
	Input.action_press("rotate_up")


## [c-up] button is _released_.
func _on_button_c_up_released() -> void:
	Input.action_release("rotate_up")


## [l] button is _pressed_.
func _on_button_r_pressed() -> void:
	Input.action_press("hold")

## [l] button is _released_.
func _on_button_r_released() -> void:
	Input.action_release("hold")
