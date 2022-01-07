extends Area2D
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_Coin_area_entered(area):
	emit_signal("hit")
	queue_free()
	
func start(pos):
	position = pos
	show()

