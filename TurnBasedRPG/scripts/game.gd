extends Node2D

var turn = 0
# 0, 2, 4... çift sayı ise -> Boss'un turu
# 1, 3, 5... tek sayı ise -> Bizim turumuz

func _ready(): # --> Oyun başlangıcında ayarlanacak şeyler
	if CharacterSelection.choice == 1:
		$Player/Sprite2D.texture = preload("res://assets/elementalist.png")
	elif CharacterSelection.choice == 2:
		$Player/Sprite2D.texture = preload("res://assets/knight.png")
	elif CharacterSelection.choice == 3:
		$Player/Sprite2D.texture = preload("res://assets/death.png")
	$ColorRect.visible = false
	toggle_buttons()
	$TurnLabel.visible = false
	play_turn()
	
func play_turn():
	$Timer.start(1)
	await $Timer.timeout
	if turn % 2 == 0:
		show_turn_label_text("Boss' Turn")
		$Timer.start(1)
		await $Timer.timeout
		$Boss/AnimationPlayer.play("deal_damage")
		$Player/PlayerHPBar.value -= 8
		if $Player/PlayerHPBar.value <= 0:
			$ColorRect.visible = true
			return
		turn += 1
		$Timer.start(1)
		await $Timer.timeout
		show_turn_label_text("Your Turn")
		play_turn()
	else:
		toggle_buttons()
		pass
		
func toggle_buttons():
	if $Button.disabled == false: #Basabiliyorsam hepsini disabled yap
		$Button.disabled = true
		$Button2.disabled = true
		$Button3.disabled = true
		$Button4.disabled = true
	else: # Basamıyorsam hepsini disabledlıktan çıkar
		$Button.disabled = false
		$Button2.disabled = false
		$Button3.disabled = false
		$Button4.disabled = false

func show_turn_label_text(text: String):
	$TurnLabel.visible = true
	$TurnLabel.text = text
	$Timer.start(1)
	await $Timer.timeout
	$TurnLabel.visible = false

func _on_button_pressed(): # Slash butonuna basıldığında
	$Player/AnimationPlayer.play("deal_damage")
	$Boss/AnimationPlayer.play("take_damage")
	$Boss/BossHPBar.value -= 5
	turn += 1
	toggle_buttons()
	play_turn()

func _on_button_2_pressed(): # Fireball butonuna basıldığında
	if $Player/PlayerManaBar.value < 15:
		pass
	else: # Yeterli manamız varsa
		$Player/AnimationPlayer.play("deal_damage")
		$Boss/AnimationPlayer.play("take_damage")
		$Boss/BossHPBar.value -= 15
		$Player/PlayerManaBar.value -= 15
		turn += 1
		toggle_buttons()
		play_turn()

func _on_button_3_pressed(): # Heal butonuna basıldığında
	$Player/PlayerHPBar.value += 10
	turn += 1
	toggle_buttons()
	play_turn()

func _on_button_4_pressed():
	$Player/PlayerManaBar.value = $Player/PlayerManaBar.max_value
	turn += 1
	toggle_buttons()
	play_turn()


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_back_to_mm_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
