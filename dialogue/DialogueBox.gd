extends Control

var test_dialogue = ["Hello?", "Hello?", "Is this thing on?", "Is it working?"] #not used
var dialogue_index = 0 #step of current conversation node, 0 is first
var current_dialogue=null #conversation json
var dialogue_node=0 #node of the conversation, 0 is first node
var tween_running=false #if we are not tweening, key advances to next text. If we are, it cancels anim and makes text visible
var on_choice=false #if we are not looking at choices, key press advances text or skips. If on choice, don't do that.

func _ready():
	visible=false
	$Option0/OptionButton.disabled=true
	$Option1/OptionButton.disabled=true
	$Option2/OptionButton.disabled=true



func _input(event):
	if event.is_action_pressed("interact") && current_dialogue!=null:
		advance_dialogue()

func load_dialogue(dialogueAddress):
	if(current_dialogue==null):
		get_tree().paused = true
		var file= File.new()
		file.open(dialogueAddress,file.READ)
		var my_dialogue=JSON.parse(file.get_as_text()).result
		current_dialogue=my_dialogue
		visible=true
		$Option0.visible=false
		$Option1.visible=false
		$Option2.visible=false
		advance_dialogue()
	else:
		assert(false,"ERROR: attempted to load dialogue when dialogue already running. How did this happen?")


func advance_dialogue():
	if tween_running==true:
		$Tween.stop($RichTextLabel,"percent_visible")
		_on_Tween_tween_completed(null,null) #args not needed
	elif dialogue_index < current_dialogue.dialogue_nodes[dialogue_node].text.size():
		$pointer.visible=false
		$RichTextLabel.bbcode_text = current_dialogue.dialogue_nodes[dialogue_node].text[dialogue_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		tween_running=true
		dialogue_index += 1
	elif on_choice==false:
		exit_dialogue()
	else:
		#pick an option coward, you don't just get to skip out!
		pass

func exit_dialogue():
	visible=false
	on_choice=false
	current_dialogue=null
	dialogue_index=0
	dialogue_node=0
	get_tree().paused = false

func _on_Tween_tween_completed(_object, _key):
	$pointer.visible=true
	$RichTextLabel.percent_visible=1
	tween_running=false
	#if last bit of text for this node finished, and this node has options
	if(dialogue_index==current_dialogue.dialogue_nodes[dialogue_node].text.size() && current_dialogue.dialogue_nodes[dialogue_node].has("options")):
		on_choice=true
		$Option0.visible=true
		$Option0/OptionButton.disabled=false
		$Option0/OptionText.bbcode_text=current_dialogue.dialogue_nodes[dialogue_node].options[0].text
		if(current_dialogue.dialogue_nodes[dialogue_node].options.size()>1):
			$Option1.visible=true
			$Option1/OptionButton.disabled=false
			$Option1/OptionText.bbcode_text=current_dialogue.dialogue_nodes[dialogue_node].options[1].text
			if(current_dialogue.dialogue_nodes[dialogue_node].options.size()>2):
				$Option2.visible=true
				$Option2/OptionButton.disabled=false
				$Option2/OptionText.bbcode_text=current_dialogue.dialogue_nodes[dialogue_node].options[2].text
		#CHOICES ONLY GO UP TO THREE. WHY? BECAUSE.

func endChoice():
	on_choice=false
	dialogue_index=0
	$Option0/OptionButton.disabled=true
	$Option0.visible=false
	$Option1/OptionButton.disabled=true
	$Option1.visible=false
	$Option2/OptionButton.disabled=true
	$Option2.visible=false
	advance_dialogue()

func _on_OptionButton_pressed(button_num):
	if (on_choice):
		if(current_dialogue.dialogue_nodes[dialogue_node].options[button_num].has("goto")):
			dialogue_node=current_dialogue.dialogue_nodes[dialogue_node].options[button_num].goto
			endChoice()
		else:
			print("does not have goto")
			exit_dialogue()
	else:
		assert(false, "How was button pressed while not on choice?")
