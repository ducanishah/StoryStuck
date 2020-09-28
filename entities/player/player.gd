extends KinematicBody2D

#default velocity of zero
var velocity = Vector2.ZERO
#default state of move (and idle, as they are the same state)
var state = MOVE
#default roll direction is left, to match default sprite
var roll_vector = Vector2.LEFT

#sets variables as soon as they are ready, easier to refer to in code
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

#constants, of course
const MAX_SPEED = 150
const ACCELERATION = 600
const FRICTION = 600
const ROLL_SPEED = 225

#saving states as numeric values
enum {
	MOVE,
	DASH
}

func _ready():
	#set animation tree to active so that animations will run
	animationTree.active = true

func _physics_process(delta):
	#change state every frame
	match state:
		MOVE:
			move_state(delta)
		DASH:
			dash_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Dash/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("dash"):
		state = DASH

func dash_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Dash")
	move()

func move():
	velocity = move_and_slide(velocity)

func dash_animation_finish():
	velocity = velocity/2
	state = MOVE
