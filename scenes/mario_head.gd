extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("hello")

func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		animation_player.play("idle")
