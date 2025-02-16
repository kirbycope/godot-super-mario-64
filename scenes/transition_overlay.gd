extends ColorRect

@export var transition_duration := 1.0
@export var star_points := 5

var shader = preload("res://scenes/star_transition.gdshader")
var progress := 0.0

func _ready():
	material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("progress", 0.0)
	material.set_shader_parameter("star_points", star_points)
	
func start_transition():
	progress = 0.0
	var tween = create_tween()
	tween.tween_property(self, "progress", 1.0, transition_duration)
	tween.tween_method(update_shader_progress, 0.0, 1.0, transition_duration)

func update_shader_progress(value: float):
	material.set_shader_parameter("progress", value)
