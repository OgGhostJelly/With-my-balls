extends Node

signal state_changed


@export var scenes = {
	circle = preload("res://objects/shape/circle/circle.tscn"),
	square = preload("res://objects/shape/square/square.tscn"),
	triangle = preload("res://objects/shape/triangle/triangle.tscn"),
	
	joint = preload("res://objects/joint/joint.tscn"),
}


var states: = {
	place_circle = place.bind(scenes.circle),
	place_square = place.bind(scenes.square),
	place_triangle = place.bind(scenes.triangle),
	
	move_push = move.bind(1),
	move_pull = move.bind(-1),
	move_drag = func drag(): printerr('Dragging is outdated please fix'),
	
	joint_join = join,
	delete = delete
}


var state: Callable = states.move_drag:
	set(v): state = v; state_changed.emit()

var push_radius: float = 180.0
var push_impulse: float = 500.0

var pull_radius: float = 360.0
var pull_force: float = 10000.0

var is_interact_pressed: bool = false


func _physics_process(_delta: float) -> void:
	state.call()
	PhysicsJointDragger.enabled = state == states.move_drag


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("interact"):
		is_interact_pressed = event.is_pressed()


var place_timer_ref: WeakRef = weakref(null)
var place_wait: float = 0.01

func place(scene: PackedScene) -> void:
	if not is_interact_pressed:
		return
	
	if place_timer_ref.get_ref():
		return
	
	var tree: SceneTree = get_tree()
	
	place_timer_ref = weakref(tree.create_timer(place_wait))
	
	var obj: RigidBody2D = scene.instantiate()
	obj.global_position = tree.current_scene.get_global_mouse_position()
	tree.current_scene.add_child(obj)


var move_timer_ref: WeakRef = weakref(null)
var move_wait: float = 0.01

func move(modification: float) -> void:
	if not is_interact_pressed:
		return
	
	if move_timer_ref.get_ref():
		return
	
	var tree: SceneTree = get_tree()
	
	move_timer_ref = weakref(tree.create_timer(move_wait))
	
	var mouse_position: Vector2 = tree.current_scene.get_global_mouse_position()
	var space_state: PhysicsDirectSpaceState2D = tree.current_scene.get_world_2d().direct_space_state
	
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.transform = Transform2D(0, mouse_position)
	query.shape = CircleShape2D.new()
	query.shape.radius = push_radius
	
	var result: Array[Dictionary] = space_state.intersect_shape(query)
	
	for collision_info in result:
		if not collision_info.collider is RigidBody2D:
			continue
		
		var collider: RigidBody2D = collision_info.collider
		
		collider.apply_impulse(mouse_position.direction_to(collider.global_position) * (1 - ( mouse_position.distance_to(collider.global_position) / push_radius )) * push_impulse * modification)


var drag

func join() -> void:
	var create_joint: Callable = func create_joint(node1: Node, node2: Node):
		var obj: Joint2D = scenes.joint.instantiate()
		obj.node_a = node1.get_path()
		obj.node_b = node2.get_path()
		node1.add_child(obj)
	
	
	if Input.is_action_just_released("interact"):
		var hover = Mouse.hover[0] if not Mouse.hover.is_empty() else null
		
		if is_instance_valid(drag) and is_instance_valid(hover):
			create_joint.call(drag.object, hover.object)
	
	drag = Mouse.drag


func delete() -> void:
	if not is_interact_pressed:
		return
	
	if Mouse.hover.is_empty():
		return
	
	if not is_instance_valid(Mouse.hover[0]):
		return
	
	Mouse.hover[0].get_parent().queue_free()
