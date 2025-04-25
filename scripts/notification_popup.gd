extends Control

func _on_timer_timeout():
	$PopupPanel.hide()

func show_text(text: String, time: float = 0.7):
	$PopupPanel/Label.text = text
	$PopupPanel.show()
	$PopupPanel/Timer.start(time)
