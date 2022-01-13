extends Node

export (PackedScene) var Mob
export (PackedScene) var Coin
export (PackedScene) var Emerald
var score
var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func update_score(points):
	score += points
	$HUD.update_score(score)
	
func gen_rand_pos():
	var x_range = Vector2(50, 974)
	var y_range = Vector2(50, 550)
	var random_x = randi() % int(x_range[1]- x_range[0]) + 1 + x_range[0] 
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(random_x, random_y)
	return random_pos

func new_coin():
	var coin = Coin.instance()
#	Deferred ensures the function is thread safe
	call_deferred("add_child", coin)
	coin.position = gen_rand_pos()
	coin.connect("hit", self, "new_coin")
	coin.connect("hit", self, "update_score", [100])
	
func new_emerald():
	$HUD.update_tip()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(10), "timeout")
	var emerald = Emerald.instance()
	call_deferred("add_child", emerald)
	emerald.position = gen_rand_pos()
	emerald.connect("hit", self, "new_emerald")
	emerald.connect("hit", self, "update_score", [500])
	

func gamer_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("emeralds", "queue_free")
	$Music.stop()
	$DeathSound.play() 
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepárate")
	$Music.play()
	new_coin()
	new_emerald()

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	call_deferred("add_child", mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_StartTimer_timeout():
	$MobTimer.start()
