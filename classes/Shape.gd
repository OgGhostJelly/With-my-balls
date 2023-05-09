extends RigidBody2D
class_name Shape


@export var colors: Array[Color] = [
	Color(255, 0, 0),
	Color(255, 125, 0),
	Color(255, 255, 0),
	Color(0, 255, 0),
	Color(0, 0, 255),
	Color(0, 255, 255),
	Color(255, 0, 255)
]
@onready var sprite: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	pass
	#sprite.rotation = -rotation
	#sprite.modulate = colors[clamp(floor( abs( ( global_position.y - 550 ) / ( colors.size() * 22 ) ) ), 0, colors.size() - 1)]
	#sprite.modulate = colors[fmod(floor(Time.get_ticks_msec() / 100), colors.size())]


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
