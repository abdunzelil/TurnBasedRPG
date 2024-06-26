extends Node2D

func _on_button_pressed():
	get_tree().root.get_node("Game/Boss/BossHPBar").value -= 5
	$PlayerManaBar.value = $PlayerManaBar.max_value
