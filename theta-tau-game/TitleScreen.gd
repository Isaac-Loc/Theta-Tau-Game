extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	pass # Replace with function body.


func _on_Quit_Button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
