extends Node


@onready var mouse: PhysicsBody2D = $Mouse
@onready var joint: Joint2D = $Mouse/Joint

var enabled: bool = true:
	set(v):
		if enabled != v:
			enabled = v
			joint.node_b = NodePath()


func _ready() -> void:
	Mouse.drag_changed.connect(_on_drag_changed)


func _physics_process(_delta: float) -> void:
	mouse.global_position = mouse.get_global_mouse_position()


func _on_drag_changed(_old_value: Node) -> void:
	if not enabled:
		return
	
	joint.node_b = (
		Mouse.drag.object.get_path()
		if is_instance_valid(Mouse.drag) else
		NodePath()
	)
