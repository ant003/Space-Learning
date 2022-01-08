extends Area2D
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	pass

func _on_Coin_area_entered(area):
	emit_signal("hit")
#	$CollisionShape2D.set_deferred("disabled", true)
	call_deferred("queue_free") # 
	#queue_free()
	
func start(pos):
	position = pos
	show()
#	$CollisionShape2D.disabled = false

