extends KinematicBody

export(float, 0, 25, 0.01) var moveSpeed = 7.5
export(float, 0, 25, 0.01) var jumpSpeed = 6.5
export(float, -5, -0.1, 0.001) var fallSpeed = -0.326
export(float, 0,90) var maxSlopeAngle = 35
export(float,0,1000) var health = 100
export(float,0,200) var push = 5
export(float, 0, 25) var phaseSpeed = 1.5
export(int, 0, 3) var respawnsRemaining = 0

const menuOpened = preload("res://assets/resources/menu_opened.tres")
const healthUI = preload("res://assets/resources/player_health.tres")
const respawnCountUI = preload("res://assets/resources/player_respawns_left.tres")

var phasing = false
var velocity : Vector3 = Vector3()

signal player_died

onready var defaultMoveSpeed = moveSpeed
onready var occupiedAreaNode = get_node("OccupiedArea")

func _ready():
	update_ui()

func _unhandled_input(event):
	if(menuOpened.Value):
		return
	if(event.is_action("phase") and event.is_pressed()):
		phase()
		get_tree().get_root().set_input_as_handled()
	if(event.is_action_released("phase")):
		end_phase()
		get_tree().get_root().set_input_as_handled()

func _physics_process(_delta): # Use physics because this uses a KinematicBody.
	if(menuOpened.Value):
		return
	move()

# Move this object.
func move():
	calculate_movement()
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector3.UP, true, 10, deg2rad(maxSlopeAngle), false)
	push_rigid_bodies()

func phase():
	if(phasing == false):
		moveSpeed = phaseSpeed
		set_collision_mask_bit(2,false)
		get_node("Camera/GunBelt").disable_weapons()
	phasing = true

func end_phase():
	if(occupiedAreaNode.is_clear() == false):
		yield (occupiedAreaNode, "area_empty")
	moveSpeed = defaultMoveSpeed
	set_collision_mask_bit(2,true)
	phasing = false
	get_node("Camera/GunBelt").enable_weapons()
	
# Pushes any rigid body this object collides with in a realistic way.
func push_rigid_bodies():
	if(phasing):
		return
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if(collision.collider.is_in_group("Props") and collision.get_collider().mode != 1):
			print("Pushing")
			collision.collider.apply_central_impulse(-collision.normal * push)

# Calculates this objects velocity.
func calculate_movement():
	velocity.x = get_input().x * moveSpeed
	velocity.z = get_input().z * moveSpeed
	velocity.y = gravity() + jump()

# Returns player input as normalized Vector3.
func get_input():
	var inputDirection = Vector3()
	if Input.is_action_pressed("move_forward"):
		inputDirection += transform.basis.z
	if Input.is_action_pressed("move_backward"):
		inputDirection -= transform.basis.z
	if Input.is_action_pressed("move_right"):
		inputDirection -= transform.basis.x
	if Input.is_action_pressed("move_left"):
		inputDirection += transform.basis.x

	inputDirection = inputDirection.normalized() # Normalize vector so speed is constant in all directions.
	return inputDirection

# Returns a negative value to simulate "gravity".
func gravity():
	if self.is_on_floor(): # Apply a small constant down force to keep grounded.
		return -0.1
	else:
		return velocity.y + fallSpeed

# Returns a positive value to "jump".
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		return jumpSpeed
	else:
		return 0

# Flips damage value to negative.
func damage(_attacker = null, value = 0.0):
	if(health - value <= 0):
		print(name, " is destroyed.")
		if(respawnsRemaining > 0):
			respawnsRemaining -= 1
			emit_signal("player_died", self, true)
		else:
			emit_signal("player_died", self)
	else:
		health -= value
		print(name, " health = ", health)
	update_ui()

func update_ui():
	respawnCountUI.Value = respawnsRemaining
	healthUI.Value = health
	
func kill():
	damage(null, health)
