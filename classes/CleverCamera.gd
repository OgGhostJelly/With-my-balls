extends Camera2D
class_name CleverCamera


@export var speed: float = 1000.0
@export var min_position: Vector2 = -Vector2.ONE * 1152
@export var max_position: Vector2 = Vector2.ONE * 1152
@export var zoom_speed: float = 1.0
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2


func _physics_process(delta: float) -> void:
	global_position += Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	) * speed * delta
	
	global_position = global_position.clamp(min_position, max_position)
	
	zoom += Vector2.ONE * Input.get_axis("zoom_out", "zoom_in") * zoom_speed * delta
	zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
