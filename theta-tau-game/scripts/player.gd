extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

const SPEED = 100
const SPRINT_MULTIPLIER = 1.35
var current_direction = "none"

@onready var world = $"../"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$regen_timer.start()  # Start the regen timer if not autostart
	$regen_timer.timeout.connect(_on_regen_timer_timeout)  # Connect the signal (can also do this in the editor)

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	if world.paused:
		return
	var current_speed = SPEED

	if Input.is_action_pressed("sprint"):
		current_speed *= SPRINT_MULTIPLIER

	var moving = false

	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		current_direction = "right_down"
		velocity = Vector2(current_speed, current_speed)
		moving = true
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		current_direction = "right_up"
		velocity = Vector2(current_speed, -current_speed)
		moving = true
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		current_direction = "left_down"
		velocity = Vector2(-current_speed, current_speed)
		moving = true
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		current_direction = "left_up"
		velocity = Vector2(-current_speed, -current_speed)
		moving = true
	elif Input.is_action_pressed("ui_right"):
		current_direction = "right"
		velocity = Vector2(current_speed, 0)
		moving = true
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		velocity = Vector2(-current_speed, 0)
		moving = true
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		velocity = Vector2(0, current_speed)
		moving = true
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		velocity = Vector2(0, -current_speed)
		moving = true
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if not attack_ip:
		play_anim(moving)

func play_anim(movement):
	var anim = $AnimatedSprite2D

	if current_direction in ["right", "right_down", "right_up"]:
		anim.flip_h = false
		anim.play("side_walk" if movement else "side_idle")
	elif current_direction in ["left", "left_down", "left_up"]:
		anim.flip_h = true
		anim.play("side_walk" if movement else "side_idle")
	elif current_direction == "down":
		anim.play("front_walk" if movement else "front_idle")
	elif current_direction == "up":
		anim.play("back_walk" if movement else "back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack") and not attack_ip:
		global.player_current_attack = true
		attack_ip = true

		match current_direction:
			"right", "right_down", "right_up":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
			"left", "left_down", "left_up":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
			"down":
				$AnimatedSprite2D.play("front_attack")
			"up":
				$AnimatedSprite2D.play("back_attack")

		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func update_health():
	var healthbar = $healthBar
	healthbar.value = health
	healthbar.visible = health < 100

func _on_regen_timer_timeout() -> void:
	if player_alive and health < 100:
		health += 20
		health = min(health, 100)
		update_health()
