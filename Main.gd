extends Node

export(PackedScene) var mob_scene
var score

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")

func _ready():
	randomize()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	# create mob
	var mob = mob_scene.instance()
	# generator random location
	var location = $MobPath/MobSpawnLocation
	location.offset = randi()
	# set mob position and rotation
	mob.position = location.position
	mob.rotation = location.rotation + PI/2 + rand_range(-PI / 4, PI / 4)
	# set mob velocity
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(mob.rotation)
	# add to scene
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
