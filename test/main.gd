extends Node

@export var mob_scene: PackedScene
var score

func new_game(): # connected to HUD.start_game
	get_tree().call_group("mobs", "queue_free") # removes mobs from previous game
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func game_over(): # connected to Player.hit()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() 
	mob.position = mob_spawn_location.position
	
	# Set the mob's direction perpendicular to the path's direction
	var direction = mob_spawn_location.rotation + PI / 2
	# add some randomness
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# finally spawns the mob with above specifics
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
