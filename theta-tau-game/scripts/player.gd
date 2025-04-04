extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

const SPEED = 100
const SPRINT_MULTIPLIER = 1.35
var current_direction = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	var current_speed = SPEED

	# Don't update animations if attacking
	if attack_ip:
		return

	if Input.is_action_pressed("sprint"):
		current_speed *= SPRINT_MULTIPLIER

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

	if current_direction in ["right", "right_down", "right_up"]:
		anim.flip_h = false
		if movement:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	elif current_direction in ["left", "left_down", "left_up"]:
		anim.flip_h = true
		if movement:
			anim.play("side_walk")
		else:
			anim.play("side_idle")
	elif current_direction == "down":
		if movement:
			anim.play("front_walk")
		else:
			anim.play("front_idle")
	elif current_direction == "up":
		if movement:
			anim.play("back_walk")
		else:
			anim.play("back_idle")

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

	# Return to idle animation after attack ends
	match current_direction:
		"right", "right_down", "right_up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_idle")
		"left", "left_down", "left_up":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_idle")
		"down":
			$AnimatedSprite2D.play("front_idle")
		"up":
			$AnimatedSprite2D.play("back_idle")
