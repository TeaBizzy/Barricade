extends Node
# Stores money, and handles receiving and spending it.

const uiMoney = preload("res://assets/resources/money.tres") # The UI variable.

export (int, 0) var startingMoney = 1000 # Money player starts with.
export (int) var maxMoney = 100000 # Maximum amount of money they player can have.
var money = 0# Amount of money this player owns.


func _ready():
	add_money(startingMoney)

# Adds money to the wallet.
func add_money(value):
	if(money + value > maxMoney):
		money = maxMoney
	else:
		money += value
	update_UI()

# Removes money from the wallet. Returns true or false if funds are available.
func spend_money(value):
	# Purchase fails if funds are insufficent, or player is phasing.
	if(money - value < 0 or find_parent("FPSPlayer").is_phasing()):
		return false 
	else:
		money -= value
		update_UI()
		return true

# Updates the UI element.
func update_UI():
	uiMoney.Value = money
