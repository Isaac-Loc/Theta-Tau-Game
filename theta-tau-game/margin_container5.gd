extends MarginContainer


@onready var label=$HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	add_text("KEVIN.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_text(next_text):
	label.text=next_text
