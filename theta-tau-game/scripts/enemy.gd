extends CharacterBody2D

var speed = 20  # Lower = slower movement
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

@onready var healthbar = $Healthbar

# Knockback settings
var knockback_vector = Vector2.ZERO
var knockback_strength = 150.0
var knockback_damping = 8.0

func _ready():
	healthbar.init_health(health)


func _physics_process(delta):
	deal_with_damage()
	
	if knockback_vector.length() > 1:
		velocity = knockback_vector
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, knockback_damping)
	else:
		if player_chase and player:
			var direction = (player.position - position).normalized()
			velocity = direction * speed
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = player.position.x < position.x
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("idle")
	
	move_and_slide()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack:
		if can_take_damage:
			health -= 20
			update_health()
			$take_damage_cooldown.start()
			can_take_damage = false

			# Apply knockback away from player
			if player:
				var away = (position - player.position).normalized()
				knockback_vector = away * knockback_strength
			
			print("slime health = ", health)
			if health <= 0:
				queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	healthbar.value = health
	healthbar.visible = health <= 100
