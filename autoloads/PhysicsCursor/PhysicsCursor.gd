extends Node

signal state_changed


@export var scenes = {
	circle = preload("res://objects/shape/circle/circle.tscn"),
	square = preload("res://objects/shape/square/square.tscn"),
	triangle = preload("res://objects/shape/triangle/triangle.tscn"),
}


var states:  = {
	place = {
		circle = place.bind(scenes.circle),
		square = place.bind(scenes.square),
		triangle = place.bind(scenes.triangle)
	},
	
	move = {
		push = move.bind(1),
		pull = move.bind(-1),
		drag = func(): printerr('Dragging is outdated please fix')
	}
}


var state: Callable = states.move.drag:
	set(v): state = v; state_changed.emit()

var push_radius: float = 180.0
var push_impulse: float = 500.0

var pull_radius: float = 360.0
var pull_force: float = 10000.0

var is_interact_pressed: bool = false


func _physics_process(_delta: float) -> void:
	state.call()
	PhysicsJointDragger.enabled = state == states.move.drag


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action("interact"):
		return
	
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
