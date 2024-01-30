extends Node


var player_current_attack = false

var current_scene = "world"
var transition_world = false
var transition_cliff = false
var transition_dungeon = false

var player_exit_cliffside_posx = 508 
var player_exit_cliffside_posy = 22
var player_start_posx =530
var player_start_posy = 55

var game_first_loadin = true

func finish_changescene():
	if transition_cliff == true:
		transition_cliff = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
	elif transition_world == true:
		transition_world = false
		if current_scene == "cliff_side":
			current_scene = "world"
		else:
			current_scene = "cliff_side"
	elif transition_dungeon == true:
		transition_dungeon = false
		if current_scene == "cliff_side":
			current_scene = "dungeon"
		else:
			current_scene = "cliff_side"
	
