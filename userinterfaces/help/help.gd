extends TextureButton


@onready var popup: Popup = $Popup


func _ready() -> void:
	popup.popup_centered(Vector2.ONE * 500)


func _on_pressed() -> void:
	popup.show()
