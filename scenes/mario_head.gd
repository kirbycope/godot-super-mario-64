extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var mesh_arrays = []
var original_vertices = []
var original_materials = []
var is_dragging = false
var grabbed_vertices = []
var closest_surface_idx = -1
var deform_radius = 0.3
var grab_radius = 0.1
var drag_start_pos = Vector3.ZERO
var drag_plane_normal = Vector3.ZERO
var zoom_level: int = 0
var last_touch_pos = Vector2.ZERO


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		reset_mesh()
		return

	var camera = get_viewport().get_camera_3d()
	if not camera:
		return

	# Handle both mouse and touch input for pressing/releasing
	if ((event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or 
		event is InputEventScreenTouch):
		
		var event_position: Vector2
		var is_pressed: bool
		
		if event is InputEventMouseButton:
			event_position = event.position
			is_pressed = event.pressed
		else: # InputEventScreenTouch
			event_position = event.position
			is_pressed = event.pressed
			
		if is_pressed:
			last_touch_pos = event_position
			var from = camera.project_ray_origin(event_position)
			var to = from + camera.project_ray_normal(event_position) * 100

			# Find closest point first
			var min_dist = INF
			var closest_point = Vector3.ZERO
			closest_surface_idx = -1
			grabbed_vertices.clear()
			for surface_idx in range(mesh_arrays.size()):
				var vertices = mesh_arrays[surface_idx][Mesh.ARRAY_VERTEX]
				for i in range(vertices.size()):
					var vertex = vertices[i]
					var global_vertex = mesh_instance.global_transform * vertex
					var dist = get_distance_to_ray(global_vertex, from, to)
					if dist < min_dist:
						min_dist = dist
						closest_point = global_vertex
						closest_surface_idx = surface_idx

			if min_dist < 0.5:
				# Grab all vertices within grab_radius of the closest point
				var vertices = mesh_arrays[closest_surface_idx][Mesh.ARRAY_VERTEX]
				for i in range(vertices.size()):
					var vertex = vertices[i]
					var global_vertex = mesh_instance.global_transform * vertex
					var dist = global_vertex.distance_to(closest_point)
					if dist < grab_radius:
						grabbed_vertices.append(i)

				if grabbed_vertices.size() > 0:
					is_dragging = true
					drag_start_pos = closest_point
					drag_plane_normal = (camera.global_position - closest_point).normalized()

		else:
			is_dragging = false
			# Only reset mesh if we're not holding AND not interacting with UI
			var touching_ui = false
			for button in get_tree().get_nodes_in_group("touch_buttons"):
				if button is TouchScreenButton and button.is_pressed():
					touching_ui = true
					break
			if not Input.is_action_pressed("hold") and not touching_ui:
				reset_mesh()

	# Handle both mouse motion and touch drag
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and is_dragging:
		var event_position: Vector2 = event.position
		var from = camera.project_ray_origin(event_position)
		var dir = camera.project_ray_normal(event_position)
		
		var t = (drag_start_pos.dot(drag_plane_normal) - from.dot(drag_plane_normal)) / dir.dot(drag_plane_normal)
		var current_pos = from + dir * t
		
		var drag_delta = current_pos - drag_start_pos
		
		var surface_arrays = mesh_arrays[closest_surface_idx]
		var vertices = surface_arrays[Mesh.ARRAY_VERTEX]
		
		var local_delta = mesh_instance.global_transform.basis.inverse() * drag_delta
		
		# Move grabbed vertices and affect nearby ones
		for grabbed_idx in grabbed_vertices:
			vertices[grabbed_idx] += local_delta
			
			# Affect nearby vertices for smoother transition
			for i in range(vertices.size()):
				if not i in grabbed_vertices:
					var dist = vertices[i].distance_to(vertices[grabbed_idx])
					if dist < deform_radius:
						var influence = pow(1.0 - (dist / deform_radius), 2)
						vertices[i] += local_delta * influence * 0.5
		
		surface_arrays[Mesh.ARRAY_VERTEX] = vertices
		mesh_arrays[closest_surface_idx] = surface_arrays
		
		update_mesh()
		
		drag_start_pos = current_pos

	if event.is_action_pressed("zoom"):
		switch_zoom_level()


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Check if the animation player is not playing
	if not animation_player.is_playing():

		# Play the "idle" animation
		animation_player.play("idle")

	# [rotate_down] action is _pressed_
	if Input.is_action_pressed("rotate_down"):
		# Rotate the mesh downwards
		rotation.x += delta * 2

	# [rotate_left] action is _pressed_
	if Input.is_action_pressed("rotate_left"):

		# Rotate the mesh to the left
		rotation.y -= delta * 2

	# [rotate_right] action is _pressed_
	if Input.is_action_pressed("rotate_right"):

		# Rotate the mesh to the right
		rotation.y += delta * 2

	# [rotate_up] action is _pressed_
	if Input.is_action_pressed("rotate_up"):

		# Rotate the mesh upwards
		rotation.x -= delta * 2


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Get the mesh arrays
	for surface_idx in range(mesh_instance.mesh.get_surface_count()):

		# Get the surface arrays
		var surface_arrays = mesh_instance.mesh.surface_get_arrays(surface_idx)

		# Append the surface arrays to the mesh arrays
		mesh_arrays.append(surface_arrays)

		# Append the surface vertices to the original vertices
		original_vertices.append(surface_arrays[Mesh.ARRAY_VERTEX].duplicate())

		# Append the surface material to the original materials
		original_materials.append(mesh_instance.mesh.surface_get_material(surface_idx))


## Gets the distance from a point to a ray.
func get_distance_to_ray(point: Vector3, ray_origin: Vector3, ray_end: Vector3) -> float:

	# Calculate the ray direction
	var ray_direction = (ray_end - ray_origin).normalized()

	# Calculate the vector from the ray origin to the point
	var v = point - ray_origin

	# Calculate the distance from the point to the ray
	var t = v.dot(ray_direction)

	# Calculate the closest point on the ray to the point
	var p = ray_origin + t * ray_direction

	# Return the distance from the point to the closest point on the ray
	return point.distance_to(p)

## Resets the mesh to its original state.
func reset_mesh() -> void:

	# Get the mesh arrays
	for surface_idx in range(mesh_arrays.size()):

		# Get the surface arrays
		var surface_arrays = mesh_arrays[surface_idx]

		# Reset the surface vertices to the original vertices
		surface_arrays[Mesh.ARRAY_VERTEX] = original_vertices[surface_idx].duplicate()

		# Update the mesh arrays
		mesh_arrays[surface_idx] = surface_arrays
	
	# Update the mesh
	update_mesh()

	# Reset the dragging state
	is_dragging = false

	# Clear the grabbed vertices
	grabbed_vertices.clear()


## Updates the mesh with the new arrays.
func update_mesh() -> void:

	# Create a new mesh for the updated arrays
	var new_mesh = ArrayMesh.new()

	# Get the mesh arrays
	for idx in range(mesh_arrays.size()):
	
		# Add the surface from the arrays
		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays[idx])

		# Set the original material for the surface
		new_mesh.surface_set_material(idx, original_materials[idx])

	# Set the new mesh for the mesh instance
	mesh_instance.mesh = new_mesh


## Switches the zoom level of the mesh.
func switch_zoom_level() -> void:

	# Check if the zoom level is less than 2
	if zoom_level < 2:

		# Change the zoom level
		zoom_level += 1

		# Change the position
		position.z -= 0.2

	# Otherwise, reset the zoom level
	else:

		# Reset the zoom level
		zoom_level = 0

		# Reset the position
		position.z += 0.4
