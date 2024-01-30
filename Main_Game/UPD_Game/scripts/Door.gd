extends StaticBody2D

func _ready():
	$Door_open.visible = false
	$Door_half.visible = false
	$Door_close.visible = true
	$CollisionShape2D.disabled = false

func _on_key_door_opened():
	$Door_open.visible = true
	$Door_half.visible = false
	$Door_close.visible = false
	$CollisionShape2D.disabled = true
	
