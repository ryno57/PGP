extends StaticBody3D

func on_interact():
	var ui = get_tree().get_root().get_node("GarageRoot/ComputerUI")
	if ui:
		ui.show_ui()
