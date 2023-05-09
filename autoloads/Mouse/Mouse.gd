extends Node


signal drag_changed


@export var drag_input: StringName = "interact"

var hover: Array[Node]: set = set_hover
var drag: Node = null: set = set_drag


func set_hover(value: Array[Node]) -> void:
	hover = value


func set_drag(value: Node) -> void:
	var old_value: Node = value
	drag = value
	drag_changed.emit(old_value)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action(drag_input):
		return
	
	if not event.is_pressed():
		drag = null; return
	
	hover = hover.filter(func(x): return is_instance_valid(x))
	
	if hover.is_empty():
		return
	
	hover.sort_custom(
		func(a, b):
			return a.global_position.distance_to(a.get_global_mouse_position()) < b.global_position.distance_to(b.get_global_mouse_position())
			)
	
	drag = hover[0]


func connect_area(node: Node) -> void:
	node.mouse_entered.connect(mouse_entered.bind(node))
	node.mouse_exited.connect(mouse_exited.bind(node))


func mouse_entered(node: Node) -> void:
	hover.append(node)
	set_hover(hover)


func mouse_exited(node: Node) -> void:
	hover.erase(node)
	set_hover(hover)
