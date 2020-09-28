extends Area2D
#Put me in the Interactables group so the player can detect me!
var my_dialogue=["You've been hit by","You've been struck by","A cool Dialogue box"]
var onCooldown=false

#That's your cue, showtime!
#Has a cooldown to prevent a single buttonpress from spamming
#Gets a references to the player in case you need to interact with it
func doInteract(player):
	if !onCooldown:
		player.get_node("DialogBox").load_dialogue(my_dialogue)
		onCooldown=true
		$CooldownTimer.start()

#cooldown done, enable me!
func _on_CooldownTimer_timeout():
	onCooldown=false
