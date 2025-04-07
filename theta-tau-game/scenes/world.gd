extends Node2D
@onready var pause_menu = $PauseMenu	
var paused = false

func _ready():
	pause_menu.hide()

func _process(delta):
	change_scene()
	if Input.is_action_just_pressed("pause"):
		pauseMenu() 

func pauseMenu():
	if (paused):
		pause_menu.hide()
		Engine.time_scale=1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused


func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true
		


func _on_cliffside_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
			global.finish_changescenes()
