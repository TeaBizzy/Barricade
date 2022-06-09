extends CanvasLayer
# Handles main menu input.

export (AudioStream) var music = null
export (Resource) var clickSound = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)  # Show cursor but confine to window.
	AudioManager.new_music(music)

# Starts the game with the selected level.
func _on_Start_button_up():
	AudioManager.new_sound(clickSound)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides cursor.
	GameManager.start_game()

# Loads the options menu.
func _on_Options_button_up():
	AudioManager.new_sound(clickSound)
	MenuSwitcher.load_scene("res://assets/scenes/OptionsMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	AudioManager.new_sound(clickSound)
	get_node("Popup").popup()


func _on_ui_pressed():
	AudioManager.new_sound(clickSound)
