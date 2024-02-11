extends CharacterBody2D


class_name Player

signal health_changed


var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true


@export var max_health = 500
@onready var current_health: int = max_health

var attack_ip = false
var roll_ip = false


const ACCELERATION = 500
const MAX_SPEED = 60
const FRICTION = 500

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
		
func _process(delta):
	# Get the global mouse position
	var mouse_position = get_global_mouse_position()

	# Get the position of the character
	var character_position = global_position

	# Calculate the angle between the character and the mouse
	var angle = atan2(mouse_position.y - character_position.y, mouse_position.x - character_position.x)

	# Determine the animation based on the angle
	if Input.is_action_just_pressed("attack"):
		if angle < -PI/4 and angle >= -3*PI/4:
			current_dir = "up";
		elif angle < 3*PI/4 and angle >= PI/4:
			current_dir = "down";
		elif angle < PI/4 and angle >= -PI/4:
			current_dir = "right";
		else:
			current_dir = "left";
	
	move_and_slide()
	attack()

func player_movement(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()	

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_walk")
		else:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("front_walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		$AnimatedSprite2D.play("front_idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_collide(velocity * delta)

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



func _on_sign_1_body_entered(body):
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("attack"):
		print("Interact button pressed")
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/sign1.dialogue"), "start")
		return


func _on_sign_1_mouse_entered():
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("attack"):
		print("Interact button pressed")
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/sign1.dialogue"), "start")
		return


func _on_sign_1_area_entered(area):
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("attack"):
			print("Interact button pressed")
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/sign1.dialogue"), "start")
			return
