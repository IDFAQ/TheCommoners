extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 500
var player_alive = true

<<<<<<< Updated upstream
var attack_ip = false

const speed = 100
=======
@export var max_health = 500
@onready var current_health: int = max_health

var attack_ip = false
var roll_ip = false

const ACCELERATION = 500
const MAX_SPEED = 60
const FRICTION = 500

>>>>>>> Stashed changes
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	attack()
	current_camera()
	enemy_attack()
	
	if health <= 0:
		player_alive = false #respawn
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
<<<<<<< Updated upstream
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
=======
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()	

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_collide(velocity * delta)
>>>>>>> Stashed changes

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			
			


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false 
	attack_ip = false

func current_camera():
	if Global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
		$dungeon_camera.enabled = false
	elif Global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true
		$dungeon_camera.enabled = false
	elif Global.current_scene == "dungeon":
		$world_camera.enabled = false
		$dungeon_camera.enabled = true
		$cliffside_camera.enabled = false

