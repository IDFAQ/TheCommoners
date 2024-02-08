extends CharacterBody2D

@onready var weapon = $Sword


const speed = 55
var current_dir = "none"
var attack_ip = false

func _ready():
	$Sword/Sprite2D.visible = false
	$Slash.visible = false
	pass


func _physics_process(delta):
	player_movement(delta)
	attack()

func player_movement(delta):
	if Input.is_action_pressed("ui_right") :
		current_dir = "right"
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left") :
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down") :
		current_dir = "down"
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up") :
		current_dir = "up"
		velocity.y = -speed
		velocity.x = 0
	else:
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func attack():
	weapon.visible = true
	attack_ip = true
	if Input.is_action_just_pressed("attack"):
		$Sword/Sprite2D.visible = true
		$AnimationPlayer.play("swing_right")
		await $AnimationPlayer.animation_finished
		$Sword/Sprite2D.visible = false
