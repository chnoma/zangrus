extends Node

var main_scene = preload("res://scene/mainscene.tscn")
var game_over = preload("res://scene/game_over.tscn")
var credits = preload("res://scene/credits.tscn")

func cleanup():
	GlobalVars.enemies = []
	GlobalVars.ai_pause = false
	GlobalVars.finale = false
	GlobalVars.held_keys = []

func switch_to_main():
	cleanup()
	get_tree().change_scene_to_file("res://scene/mainscene.tscn")


func switch_to_death():
	cleanup()
	get_tree().change_scene_to_packed(game_over)
	
func switch_to_credits():
	cleanup()
	get_tree().change_scene_to_packed(credits)
