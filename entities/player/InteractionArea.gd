extends Area2D
#handles detection of and proper reaction to interactable objects
#Interactable objects should all go in the group "interactables"

#the player, for distance calcs
var player
#the list of interactables we are within the area of
var interactables=[]

#get the player for distance calculations
func _ready():
	player=get_parent()

#when we intersect with an interactable's area, add it to the list
func _on_InteractionArea_area_entered(area):
	if area.get_groups().find("Interactables")>-1:
		interactables.append(area)


#remove interactables from list when we exit their area
func _on_InteractionArea_area_exited(area):
	if area.get_groups().find("Interactables")>-1:
		interactables.erase(area)

#if button, tell the closest interactable to do it's thing
func _process(_delta):
	if Input.is_action_pressed(("ui_select")) && interactables.size()>0:
		var closest_interactable=interactables[0]
		for interactable in interactables:
			if player.position.distance_to(interactable.position) < player.position.distance_to(interactable.position):
				closest_interactable=interactables
		#Give a reference to the player to the object
		closest_interactable.doInteract(get_parent())
