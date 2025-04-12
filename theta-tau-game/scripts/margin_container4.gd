extends MarginContainer


# Called when the node enters the scene tree for the first time.
@onready var label=$HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	add_text("However, it was stolen by PHI LIGMA RHO, BUT ONE saved us from 
	damnation and his name was…
")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_text(next_text):
	label.text=next_text
