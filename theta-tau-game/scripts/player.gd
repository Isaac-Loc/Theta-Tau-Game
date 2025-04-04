extends CharacterBody2D

const SPEED = 100
const SPRINT_MULTIPLIER = 1.35 # Adjust sprint speed multiplier
var current_direction = "none"
@onready var world = $"../"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if world.paused:
		return
	var current_speed = SPEED
	
	if Input.is_action_pressed("sprint"):  # Sprinting increases speed
		current_speed *= SPRINT_MULTIPLIER

	# Handle diagonal movement first
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		current_direction = "right_down"
		play_anim(1)
		velocity.x = current_speed
		velocity.y = current_speed
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		current_direction = "right_up"
		play_anim(1)
		velocity.x = current_speed
		velocity.y = -current_speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		current_direction = "left_down"
		play_anim(1)
		velocity.x = -current_speed
		velocity.y = current_speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		current_direction = "left_up"
		play_anim(1)
		velocity.x = -current_speed
		velocity.y = -current_speed
	
	# Handle single direction movement
	elif Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_anim(1)
		velocity.x = current_speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_anim(1)
		velocity.x = -current_speed
		velocity.y = 0 
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_anim(1)
		velocity.y = current_speed
		velocity.x = 0 
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_anim(1)
		velocity.y = -current_speed
		velocity.x = 0 
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var anim = $AnimatedSprite2D
	
	if current_direction == "right" or current_direction == "right_down" or current_direction == "right_up":
		anim.flip_h = false
		anim.play("side_walk" if movement else "side_idle")
	elif current_direction == "left" or current_direction == "left_down" or current_direction == "left_up":
		anim.flip_h = true
		anim.play("side_walk" if movement else "side_idle")
	elif current_direction == "down":
		anim.play("front_walk" if movement else "front_idle")
	elif current_direction == "up":
		anim.play("back_walk" if movement else "back_idle")
		
