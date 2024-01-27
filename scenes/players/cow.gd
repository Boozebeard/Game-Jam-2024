extends RigidBody2D

var biggen_speed: Vector2 = Vector2(2,2)
var smallen_speed: Vector2 = Vector2(2,2)

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		linear_velocity += Vector2.UP * 2000
		
	if Input.is_action_pressed("biggen"):
		if $Sprite2D.scale < Vector2(2.5,2.5):
			$CollisionShape2D.scale += biggen_speed * delta
			$Sprite2D.scale += biggen_speed * delta
			gravity_scale += 10 * delta
			if $Sprite2D.scale > Vector2(2.5,2.5):
				$Sprite2D.scale = Vector2(2.5,2.5)
				$CollisionShape2D.scale = Vector2(2.5,2.5)

		print(physics_material_override.bounce)
		if physics_material_override.bounce < 1:
			physics_material_override.bounce += .3 * delta
			if physics_material_override.bounce > 1:
				physics_material_override.bounce = 1

	if Input.is_action_pressed("smallen"):
		$CollisionShape2D.scale -= smallen_speed * delta
		$Sprite2D.scale -= smallen_speed * delta
		print(physics_material_override.bounce)
		if gravity_scale > 0.05:
			gravity_scale -= 10 * delta
			if gravity_scale < .05:
				gravity_scale = .05
		if physics_material_override.bounce > 0:
			physics_material_override.bounce -= .3 * delta
			if physics_material_override.bounce <= 0:
				physics_material_override.bounce = 0
