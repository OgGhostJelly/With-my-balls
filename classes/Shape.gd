extends RigidBody2D
class_name Shape


@export var colors: Array[Color] = [
	Color(1, 0, 0),
	Color(1, 0.5, 0),
	Color(1, 1, 0),
	Color(0, 1, 0),
	Color(0.5, 1, 0),
	Color(0, 0, 1),
	Color(0, 0.5, 1),
	Color(0.5, 0.5, 1),
	Color(1, 0, 1),

#	Color(1, 0, 0),
#	Color(1, 0.5, 0),
#	Color(1, 1, 0),
#	Color(0, 1, 0),
#	Color(0, 0, 1),
#	Color(0, 1, 1),
#	Color(1, 0, 1),
#	Color(1, 1, 1),
]
@onready var sprite: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	var value: float = ( global_position.y - 550 )
	var tindex: int = floor( abs( value / ( colors.size() * 5 ) ) )
	var top: int = colors.size()
	
	var color_index: float = fmod(tindex, top)
	
	sprite.modulate = colors[color_index]


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
