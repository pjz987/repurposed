extends Control

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SPACE"):
		visible = not visible
		if visible:
			
			get_tree().paused = true
		else:
			get_tree().paused = false
	
func refresh_equipped_text() -> void:
	var my_text: String = Globals.display_names[Globals.active_gun]
	print(my_text)
	$Label/Equipped/Weapon.text = my_text

func _on_basic_gun_pressed() -> void:
	if can_buy(Globals.Equipped.BASIC_GUN):
		refund()
		buy(Globals.Equipped.BASIC_GUN)
		refresh_equipped_text()
		Globals.refresh_char_sprite.emit()
		print("oil: ",  Globals.oil, "\nmetal: ",  Globals.metal)

func _on_unarmed_pressed() -> void:
	refund()
	Globals.active_gun = Globals.Equipped.FISTS
	refresh_equipped_text()
	Globals.refresh_char_sprite.emit()
	print("oil: ",  Globals.oil, "\nmetal: ",  Globals.metal)

func can_buy(weapon: Globals.Equipped) -> bool:
	if Globals.metal >= Globals.item_costs[weapon][0]:
		if Globals.oil >= Globals.item_costs[weapon][1]:
			return true
	return false

func refund() -> void:
	Globals.metal += Globals.item_costs[Globals.active_gun][0]
	Globals.oil += Globals.item_costs[Globals.active_gun][1]

func buy(weapon: Globals.Equipped) -> void:
	Globals.metal -= Globals.item_costs[weapon][0]
	Globals.oil -= Globals.item_costs[weapon][1]
	Globals.active_gun = weapon
