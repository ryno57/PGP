extends CanvasLayer

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/garage.tscn")

func _on_settings_pressed():
	print("Options à venir...")

func _on_news_pressed():
	print("Patch notes à venir...")
