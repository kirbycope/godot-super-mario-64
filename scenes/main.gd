extends Node3D

const COIN = preload("res://assets/coin.wav")
const HELLO = preload("res://assets/hello.wav")
const ITS_A_ME_MARIO = preload("res://assets/its_a_me_mario.wav")
const TITLE_THEME = preload("res://assets/title_theme.ogg")

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player_3d: AudioStreamPlayer3D = $MarioHead/AudioStreamPlayer3D
@onready var logo = $Logo/logo
@onready var logo_1996 = $"1996"
@onready var logo_tm = $TM
@onready var background = $Background
@onready var cursor = $Camera3D/CanvasLayer/Cursor
@onready var press_start = $Camera3D/CanvasLayer/PressStart
@onready var transition = $Camera3D/CanvasLayer/Transition
@onready var mario_head = $MarioHead
@onready var animation_player = $MarioHead/AnimationPlayer

func _ready():
	logo.visible = true
	logo.scale = Vector3.ZERO
	logo_1996.visible = false
	logo_tm.visible = false
	background.visible = false
	cursor.visible = false
	press_start.visible = false
	mario_head.visible = false
	start_sequence()

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
		transition.reveal()
		animation_player.play("hello")
	)
	tween.tween_interval(0.5)
	tween.tween_callback(func():
		cursor.visible = true
		press_start.visible = true
		press_start.start_toggle()
		audio_player.stream = TITLE_THEME
		audio_player.play()
		audio_player_3d.stream = HELLO
		audio_player_3d.play()
	)
