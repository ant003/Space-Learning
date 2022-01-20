extends Node

export (PackedScene) var Mob
export (PackedScene) var Coin
export (PackedScene) var Emerald
var score
# Size of the game window.
var screen_size 

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.show()
	hide_game_elem()
	randomize()
	
func hide_game_elem():
	$Player.hide()
	$StartPosition.hide()
	$MobPath.hide()
	$HUD.hide()

func show_game_elem():
	$Player.show()
	$StartPosition.show()
	$MobPath.show()
	$HUD.hide()

func update_score(points):
	score += points
	$HUD.update_score(score)
	
func gen_rand_pos():
	var x_range = Vector2(128, 974)
	var y_range = Vector2(128, 550)
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
	var emerald = Emerald.instance()
	call_deferred("add_child", emerald)
	emerald.position = gen_rand_pos()
	emerald.connect("hit", self, "reboot_temp")
	emerald.connect("hit", $HUD, "update_tip")
	emerald.connect("hit", self, "update_score", [500])

func reboot_temp():
	$EmeraldTimer.start()
	
func _on_EmeraldTimer_timeout():
	new_emerald()
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$EmeraldTimer.start()

func gamer_over():
	$Music.stop()
	$DeathSound.play() 
	$MobTimer.stop()
	$EmeraldTimer.stop()
	$HUD.show_game_over()
	yield(get_tree().create_timer(3), "timeout")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("emeralds", "queue_free")
	$HUD.hide()
	$MainMenu.show()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.load_tips()
	$MainMenu.hide()
	$HUD.show()
	$Music.play()
	new_coin()
	$HUD.show_message("Esquiva  y\natrapa monedas!")
	yield($HUD/MessageTimer, "timeout")
	$HUD.show_message("Prepárate")
	

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
