extends Spatial

onready var primaryFireNode = get_node("PrimaryFire")
onready var animationPlayer = get_node("AnimationPlayer")
export (Resource) var addAmmoSound

func _process(delta):
	if(GameManager.isPaused):
		return
	if(Input.is_action_just_pressed("reload")):
		primaryFireNode.startReload()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_pressed("primary_fire")):
		primaryFireNode.primary_fire()
		get_tree().get_root().set_input_as_handled()


func equip():
	show()
	set_process(true)
	primaryFireNode.update_ui()
	animationPlayer.play("equip")
	yield(animationPlayer, "animation_finished")


func unequip():
	if(primaryFireNode.isReloading):
		primaryFireNode.isReloading = false
	set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	hide()


# Used by external sources to add ammo to this weapon.
func add_ammo(primaryAmmo = 0, secondaryAmmo = 0):
	primaryFireNode.add_ammo(primaryAmmo)
	get_node("AudioManager").new_3d_sound(addAmmoSound)


func has_max_ammo():
	if(primaryFireNode.reserveAmmo >= primaryFireNode.maxReserveAmmo):
		return true
	else:
		return false
