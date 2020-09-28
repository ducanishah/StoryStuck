extends Control

func _ready():
	$Menu/CenterRow/buttons/newGameButton.grab_focus()
	for button in $Menu/CenterRow/buttons.get_children():
		if button != $Menu/CenterRow/buttons/exitButton:
			button.connect("pressed", self, "on_Button_pressed", [button.scene_to_load])

func on_Button_pressed(scene_to_load):
	sceneChanger.change_scene(scene_to_load)

func _on_exitButton_pressed():
	get_tree().quit()
