extends Node3D

const HELLO = preload("res://assets/hello.wav")
const ITS_A_ME_MARIO = preload("res://assets/its_a_me_mario.wav")

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var logo = $Logo/logo
@onready var logo_1996 = $"1996"
@onready var logo_tm = $TM
@onready var background = $Background
@onready var canvas_layer = $Camera3D/CanvasLayer
@onready var mario_head = $MarioHead

func _ready():
	logo.visible = true
	logo.scale = Vector3.ZERO
	logo_1996.visible = false
	logo_tm.visible = false
	background.visible = false
	canvas_layer.visible = false
	mario_head.visible = false
	start_sequence()

func start_sequence():
	audio_player.stream = ITS_A_ME_MARIO
	audio_player.play()
	var tween = create_tween()
	tween.tween_property(logo, "scale", Vector3.ONE, 1.0)
	tween.tween_property(logo, "scale", Vector3(1.1, 1.1, 1.1), 0.15)
	tween.tween_property(logo, "scale", Vector3(0.9, 0.9, 0.9), 0.15)
	tween.tween_property(logo, "scale", Vector3(1.05, 1.05, 1.05), 0.15)
	tween.tween_property(logo, "scale", Vector3(0.95, 0.95, 0.95), 0.15)
	tween.tween_property(logo, "scale", Vector3.ONE, 0.15)
	tween.tween_callback(func():
		logo_1996.visible = true
		logo_tm.visible = true
	)
	tween.tween_interval(2.5)
	tween.tween_property(logo, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(func():
		logo_1996.visible = false
		logo_tm.visible = false
		background.visible = true
		canvas_layer.visible = true
		mario_head.visible = true
	)
	audio_player.stream = HELLO
	audio_player.play()
