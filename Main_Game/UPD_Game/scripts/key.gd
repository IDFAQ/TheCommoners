extends StaticBody2D

signal chest_opened
signal door_opened

var key_taken = false
var in_chest_zone = false
var in_door_zone = false





func _process(delta):
	if key_taken == true:
		if in_chest_zone == true:
			print("chest_opened")
			emit_signal("chest_opened")
		elif in_door_zone == true:
			print("door_opened")
			emit_signal("door_opened")

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		if key_taken == false:
			key_taken = true
			$Sprite2D.queue_free()



func _on_chest_zone_body_entered(body):
	if body.has_method("player"):
		in_chest_zone = true
		print(in_chest_zone)


func _on_chest_zone_body_exited(body):
	if body.has_method("player"):
		in_chest_zone = false
		print(in_chest_zone)





func _on_door_zone_body_entered(body):
	if body.has_method("player"):
		in_door_zone = true


func _on_door_zone_body_exited(body):
	if body.has_method("player"):
		in_door_zone = false
