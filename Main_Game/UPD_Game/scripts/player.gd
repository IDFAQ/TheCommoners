extends CharacterBody2D

class_name Player

signal health_changed

var enemy_inattack_range = false
var enemy_attack_cooldown = true
# var health = 500
var player_alive = true

<<<<<<< Updated upstream
@export var max_health = 100
@onready var current_health: int = max_health
=======
var attack_ip = false
var roll_ip = false
>>>>>>> Stashed changes


var attack_ip = false
const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	
	if current_health <= 0:
		player_alive = false #respawn
		current_health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		current_dir = "down_right"
		play_anim(1)
		velocity.y = speed
		velocity.x = speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		current_dir = "down_left"
		play_anim(1)
		velocity.y = speed
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		current_dir = "up_right"
		play_anim(1)
		velocity.y = -speed
		velocity.x = speed
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		current_dir = "up_left"
		play_anim(1)
		velocity.y = -speed
		velocity.x = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()


	
	

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right" or dir == "down_right" or dir == "up_right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false and roll_ip == false:
				anim.play("side_idle")
	if dir == "left" or dir == "down_left" or dir == "up_left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false and roll_ip == false:
				anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false and roll_ip == false:
				anim.play("back_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false and roll_ip == false:
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
		current_health = current_health - 20
		health_changed.emit()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(current_health)

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
