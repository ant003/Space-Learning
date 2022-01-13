extends Area2D
signal hit


func _ready():
	pass # Replace with function body.


func _on_Emerald_area_entered(area):
	if (area.is_in_group("Player")):
		emit_signal("hit")
		call_deferred("queue_free") # 
	
func start(pos):
	position = pos
	show()
