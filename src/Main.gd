extends Node

var scenes = {
	"main_menu": preload("res://src/scenes/MainMenuScene.tscn"),
	"battle": preload("res://src/scenes/BattleScene.tscn"),
	"writing": preload("res://src/scenes/WritingScene.tscn")
}

func _ready():
	EventBus.connect("change_scene", self, "change_scene")
	
	change_scene("main_menu")

func change_scene(new_scene):
	if scenes.has(new_scene):
		
		for child in $CurrentScene.get_children():
			child.queue_free()
		
		$CurrentScene.add_child(scenes[new_scene].instance())
		
	else:
		change_scene("main_menu")
