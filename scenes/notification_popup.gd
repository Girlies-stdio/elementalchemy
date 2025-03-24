extends Control

func _on_timer_timeout():
	$PopupPanel.hide()

func show_text(text: String):
	$PopupPanel/Label.text = text
	$PopupPanel.show()
	$PopupPanel/Timer.start()
