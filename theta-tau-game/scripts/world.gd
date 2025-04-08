extends Node2D
@onready var pause_menu = $PauseMenu	
var paused = false

func _ready():
	pause_menu.hide()
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)

func _process(delta):
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



func _on_level_spawn(destination_tag: String):
	var door_path = "doors/door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
