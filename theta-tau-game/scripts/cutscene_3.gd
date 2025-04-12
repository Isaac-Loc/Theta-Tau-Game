extends Control


@onready var timer=$Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Timer started!")
		timer.start()  



func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene_4.tscn")
