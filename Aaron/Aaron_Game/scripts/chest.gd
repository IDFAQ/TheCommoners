extends StaticBody2D

func _ready():
	$Chest_open.visible = false
	$chest_close.visible = true


func _on_key_chest_opened():
	$Chest_open.visible = true
	$chest_close.visible = false
