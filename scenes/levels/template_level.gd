extends Node2D

@onready var camera01 = $PhantomCamera2D
@onready var camera02 = $PhantomCamera2D2
@onready var camera03 = $PhantomCamera2D3
@onready var camera04 = $PhantomCamera2D4
@onready var player = $Player

var save_path = "user://score.save"

func _ready():
	$AudioStreamPlayer.play()
	Globals.timer_stopped = false
	Globals.game_active = true
	load_score()

func _process(delta):
	if Input.is_anything_pressed():
		camera03.set_priority(0)
	
	if Input.is_action_just_pressed("restart"):
		reload_scene()
	
	var player_speed = abs(player.linear_velocity.x)
	
	if player_speed > 2000:
		camera01.set_priority(0)
		camera02.set_priority(1)
	if player_speed <= 2000:
		camera01.set_priority(1)
		camera02.set_priority(0)

func reload_scene():
	get_tree().change_scene_to_file.bind("res://scenes/levels/template_level.tscn").call_deferred()

func _on_slow_trap_slow_trap_entered():
	$Player.physics_material_override.bounce = 0
	$Player.linear_velocity -= $Player.linear_velocity * 0.8

func _on_wind_body_entered(body):
	if "linear_velocity" in body:
		body.add_constant_force(Vector2(0,-3000), Vector2(0,0))

func _on_wind_body_exited(body):
	if "linear_velocity" in body:
		body.constant_force = Vector2(0, 0)

func _on_level_end_body_entered(body):
	if body is RigidBody2D:
		camera04.set_priority(2)
		Globals.timer_stopped = true
		end_level()

func end_level():
	player.sleeping = true
	save_score()
	print("level end!")
	Globals.game_active = false

func save_score():
	var current_time = Globals.time
			
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		Globals.best_time = file.get_var()
	else:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(current_time)
	if current_time < Globals.best_time:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(current_time)
		Globals.best_time = current_time
		$Node2D/LeaderBoardUI.get_score()
	
func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		Globals.best_time = file.get_var()
		print(Globals.best_time)
	else:
		print("file not found")
		Globals.best_time = 99999
	$Node2D/LeaderBoardUI.get_score()
