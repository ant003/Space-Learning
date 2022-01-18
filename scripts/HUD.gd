extends CanvasLayer

signal start_game
var phrases


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func open_file(path):
	phrases = File.new()
	phrases.open(path,File.READ)
	
func update_tip():
	var tmp_phrase = phrases.get_line()
	if(phrases.eof_reached()):
		phrases.seek(0)
		tmp_phrase = phrases.get_line()
	$TopInfo/GameInfo/Tip.text = tmp_phrase

func show_message(text):
	$BottomInfo/GameInfo/Message.text = text
	$BottomInfo/GameInfo/Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Juego terminado")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	$BottomInfo/GameInfo/Message.text = "Esquiva  y\natrapa monedas!"
	$BottomInfo/GameInfo/Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$BottomInfo/GameInfo/StartButton.show()
	phrases.close()
	
func update_score(score):
	$TopInfo/GameInfo/ScoreLabel.text = str(score)
	
func _on_MessageTimer_timeout():
	$BottomInfo/GameInfo/Message.hide()

func _on_StartButton_pressed():
	open_file("phrases.txt")
	$BottomInfo/GameInfo/StartButton.hide()
	emit_signal("start_game")
