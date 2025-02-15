extends ColorRect

@onready var shader_material: ShaderMaterial = material as ShaderMaterial
var tween: Tween


func _ready():

	# Start with the screen covered
	shader_material.set_shader_parameter("progress", 0.0)

	# Wait 2 seconds before starting the reveal
	#await get_tree().create_timer(0.2).timeout
	#reveal()


func reveal():
	tween = create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 1.0, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(2.0).timeout


func cover():
	tween = create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", 0.0, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
