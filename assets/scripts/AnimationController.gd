extends AnimationPlayer

export var returnToDefaultAnimation = false
export var defaultAnimation = "" # Default animation to play after all animations.

# Check for variable errors.
func _ready():
	if(returnToDefaultAnimation and defaultAnimation == ""):
		print("ERROR: Default animation isn't defined.")

# Plays the signaled animation
func _on_change_animation(animationName):
	play(animationName)

# Plays the default animation if set.
func _on_animation_finished():
	if(returnToDefaultAnimation):
		play(defaultAnimation)
