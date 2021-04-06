extends Node

var scenes = {
	"main_menu": load("res://src/scenes/MainMenuScene.tscn"),
	"battle": load("res://src/scenes/BattleScene.tscn")
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
