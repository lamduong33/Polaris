extends CharacterBody2D

@export var moveSpeed : float = 100
@export var startingDirection : Vector2 = Vector2(0, 1)
#parameters/idle/blend_position

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

func _ready():
	updateAnimationParameters(startingDirection)

func _physics_process(_delta):
	# get input direction
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	updateAnimationParameters(inputDirection)
	
	print(inputDirection)
	# update velocity
	velocity = inputDirection * moveSpeed
	
	# move and slide function uses velocity of character body to move character on map
	move_and_slide()
	
	pickNewState()

func updateAnimationParameters(moveInput: Vector2):
	# dont change animation parameters if there is no move input
	if(moveInput != Vector2.ZERO):
		animationTree.set("parameters/walk/blend_position", moveInput)
		animationTree.set("parameters/idle/blend_position", moveInput)

# choose state based on what is happening with the player
func pickNewState():
	if(velocity != Vector2.ZERO):
		stateMachine.travel("walk")
	else:
		stateMachine.travel("idle")
