extends Node

export (PackedScene) var Mob
var score

func ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$HUD/ScoreLabel.hide()
	$HUD/LastScore.text = str(score)
	$HUD/LastScoreText.show()
	$HUD/LastScore.show()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Go")
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + TAU / 4
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-TAU / 8, TAU / 8)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD/ScoreLabel.show()
	$HUD/LastScoreText.hide()
	$HUD/LastScore.hide()
