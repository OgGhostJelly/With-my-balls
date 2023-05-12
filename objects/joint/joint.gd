extends DampedSpringJoint2D


var node1: Node2D
var node2: Node2D


func _ready() -> void:
	update_nodes()
	length = node1.global_position.distance_to(node2.global_position)


func _process(_delta: float) -> void:
	if not is_instance_valid(node1) or not is_instance_valid(node2):
		queue_free()
	
	queue_redraw()


func _draw() -> void:
	update_nodes()
	
	if not node1 or not node2:
		return
	
	var node1pos: Vector2 = to_local(node1.global_position)
	var node2pos: Vector2 = to_local(node2.global_position)
	
	draw_line(node1pos, node2pos, Color.SADDLE_BROWN, 5)


func update_nodes() -> void:
	node1 = get_node(node_a)
	node2 = get_node(node_b)
