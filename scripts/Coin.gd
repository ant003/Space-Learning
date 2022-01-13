extends Area2D
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	pass

func _on_Coin_area_entered(area):
	if (area.is_in_group("Player")):
		emit_signal("hit")
		call_deferred("queue_free")
	
	
func start(pos):
	position = pos
	show()

