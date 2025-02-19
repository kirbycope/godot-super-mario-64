extends ColorRect

@export var transition_duration := 1.0
@export var star_points := 5

var shader = preload("res://scenes/star_transition.gdshader")
var progress := 0.0


## Called when the node enters the scene tree for the first time.
func _ready():

	# Create a new ShaderMaterial
	material = ShaderMaterial.new()

	# Set the shader to the star transition shader
	material.shader = shader

	# Set the progress to 0.0
	material.set_shader_parameter("progress", 0.0)

	# Set the number of star points
	material.set_shader_parameter("star_points", star_points)


## Starts the transition.
func start_transition():

	# Set the progress to 0.0
	progress = 0.0

	# Create a new tween
	var tween = create_tween()

	# Change the progress over the transition duration
	tween.tween_property(self, "progress", 1.0, transition_duration)

	# Change the shader progress over the transition duration
	tween.tween_method(update_shader_progress, 0.0, 1.0, transition_duration)


## Updates the shader progress.
func update_shader_progress(value: float):

	# Set the shader progress
	material.set_shader_parameter("progress", value)
