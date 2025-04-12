extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene_1.tscn")
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
