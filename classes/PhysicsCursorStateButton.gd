extends TextureButton
class_name PhysicsCursorStateButton


@export var state: String
@export var display_hover_on_select: bool = true
@export var selected: Texture
@export var normal: Texture


func _ready() -> void:
	PhysicsCursor.state_changed.connect(update_display); update_display()
	
	pressed.connect(_on_pressed)


func update_display() -> void:
	var state_object = PhysicsCursor.states[state]
	
	texture_normal = (
		selected
		if PhysicsCursor.state == state_object and hash(PhysicsCursor.state) == hash(state_object) else
		normal
	)
	
	texture_hover = selected if display_hover_on_select else null


func _on_pressed() -> void:
	PhysicsCursor.state = PhysicsCursor.states[state]
