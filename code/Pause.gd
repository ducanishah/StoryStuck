extends Control

var new_pause_state
var currScene

onready var SceneChanger = get_node("/root/sceneChanger")

func _ready():
	for button in $buttons.get_children():
		if button != $buttons/resumeButton && button != $buttons/saveButton:
			button.connect("pressed", self, "on_Button_pressed", [button.scene_to_load])

func _physics_process(delta):
	currScene = get_tree().get_current_scene().get_name()

func _input(event):
	if event.is_action_pressed("ui_cancel") and currScene != "TitleScreen":
		new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		$buttons/resumeButton.grab_focus()

func _on_resumeButton_pressed():
	new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func on_Button_pressed(scene_to_load):
	new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
	SceneChanger.change_scene(scene_to_load)

func _on_saveButton_pressed():
	pass
