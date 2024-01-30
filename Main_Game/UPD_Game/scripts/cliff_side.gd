extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_world_transition_body_entered(body):
	if body.has_method("player"):
		Global.transition_world = true
		change_scenes()


func _on_dungeon_transition_body_entered(body):
	if body.has_method("player"):
		Global.transition_dungeon = true
		change_scenes()

func change_scenes():
	if Global.transition_world == true:
		if Global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_changescene()
	elif Global.transition_dungeon:
		if Global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
			Global.finish_changescene()
