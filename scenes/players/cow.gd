extends RigidBody2D

var size_change_speed = 1.2

var min_size = 1
var max_size = 2.5

var min_grav = .6
var max_grav = 8

var max_bounce = 0.7
var min_bounce = 0.4

var biggen_speed: Vector2 = Vector2(size_change_speed,size_change_speed)
var smallen_speed: Vector2 = Vector2(size_change_speed,size_change_speed)

@onready var player = $"."

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	gravity_scale = max_grav
	physics_material_override.bounce = max_bounce

func _process(delta):
	change_head()
	
	if Input.is_action_pressed("biggen") and Globals.game_active:
		if $Node2D.scale < Vector2(max_size,max_size):
			var change = ((max_size - min_size) * size_change_speed) * delta
			$CollisionShape2D.scale += Vector2(change,change)
			$Node2D.scale += Vector2(change,change)
			if $Node2D.scale > Vector2(max_size,max_size):
				$Node2D.scale = Vector2(max_size,max_size)
				$CollisionShape2D.scale = Vector2(max_size,max_size)

		decrease_gravity(delta)
		decrease_bounce(delta)

	#print("size ",$Node2D.scale,", gravity ",gravity_scale,", bounce ",physics_material_override.bounce)
	
	if Input.is_action_pressed("smallen") and Globals.game_active and !Input.is_action_pressed("biggen"):
		
		if $Node2D.scale > Vector2(min_size,min_size):
			$GPUParticles2D.emitting = true
			var change = ((max_size - min_size) * size_change_speed) * delta
			$CollisionShape2D.scale -= Vector2(change,change)
			$Node2D.scale -= Vector2(change,change)
			propel(delta)
			
			if $Node2D.scale <= Vector2(min_size,min_size):
				$GPUParticles2D.emitting = false
				$Node2D.scale = Vector2(min_size,min_size)
				$CollisionShape2D.scale = Vector2(min_size,min_size)
				
				
		increase_gravity(delta)
		increase_bounce(delta)

				
		#print("size ",$Node2D.scale,", gravity ",gravity_scale,", bounce ",physics_material_override.bounce)

	if Input.is_action_just_released("smallen") and Globals.game_active:
		$GPUParticles2D.emitting = false

func decrease_gravity(delta):
	if gravity_scale > min_grav:
		gravity_scale -= ((max_grav-min_grav) * size_change_speed) * delta
		if gravity_scale < min_grav:
			gravity_scale = min_grav

func increase_gravity(delta):
	if gravity_scale < max_grav:
		gravity_scale += ((max_grav-min_grav) * size_change_speed) * delta
		if gravity_scale > max_grav:
			gravity_scale = max_grav

func increase_bounce(delta):
	if physics_material_override.bounce < max_bounce:
		physics_material_override.bounce += ((max_bounce-min_bounce) * size_change_speed) * delta
		if physics_material_override.bounce > max_bounce:
			physics_material_override.bounce = max_bounce
			
func decrease_bounce(delta):
	if physics_material_override.bounce > min_bounce:
		physics_material_override.bounce -= ((max_bounce-min_bounce) * size_change_speed) * delta
		if physics_material_override.bounce < min_bounce:
			physics_material_override.bounce = min_bounce

func propel(delta):
	var player_direction = (get_global_mouse_position() - player.position).normalized()
	linear_velocity += ((player_direction * -1) * 3000) * delta
	$GPUParticles2D.process_material.set("direction", player_direction)

func change_head():
	if $Node2D.scale.x < 1.75:
		$Node2D/heads/head1.visible = true
		$Node2D/heads/head2.visible = false
		$Node2D/heads/head3.visible = false
	if $Node2D.scale.x >= 1.75 and $Node2D.scale.x < 2.45:
		$Node2D/heads/head1.visible = false
		$Node2D/heads/head2.visible = true
		$Node2D/heads/head3.visible = false
	if $Node2D.scale.x >= 2.45:
		$Node2D/heads/head1.visible = false
		$Node2D/heads/head2.visible = false
		$Node2D/heads/head3.visible = true

#func _on_body_entered(body):
	#$Node2D.global_scale.y -= .2


#func _on_body_exited(body):
	#$Node2D.global_scale.y += .2
