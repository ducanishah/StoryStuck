extends Control

var test_dialogue = ["Hello?", "Hello?", "Is this thing on?", "Is it working?"]
var dialogue_index = 0
var current_dialogue=null
var tween_running=false

func _ready():
	visible=false


func _input(event):
	if event.is_action_pressed("interact") && current_dialogue!=null:
		advance_dialogue()

func load_dialogue(dialogue):
	if(current_dialogue==null):
		current_dialogue=dialogue
		visible=true
		advance_dialogue()


func getTextArrayFromFile(fileURL):
	var file=File.new()
	file.open(fileURL,File.READ)
	var text=file.get_as_text()
	var textArray
	textArray=JSON.parse(text).result
	return textArray

func advance_dialogue():
	if tween_running==true:
		$Tween.stop($RichTextLabel,"percent_visible")
		$RichTextLabel.percent_visible=1
		tween_running=false
	elif dialogue_index < current_dialogue.size():
		$pointer.visible=false
		$RichTextLabel.bbcode_text = current_dialogue[dialogue_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		tween_running=true
		dialogue_index += 1
	else:
		visible=false
		current_dialogue=null
		dialogue_index=0
	

func _on_Tween_tween_completed(object, key):
	$pointer.visible=true
	tween_running=false
