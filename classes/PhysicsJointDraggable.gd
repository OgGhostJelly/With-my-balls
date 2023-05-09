extends Area2D
class_name PhysicsJointDraggable
## ## Allows dragging of [PhysicsBody2D]


## The object that gets dragged.
@export var object: PhysicsBody2D


func _enter_tree() -> void:
	Mouse.connect_area(self)
