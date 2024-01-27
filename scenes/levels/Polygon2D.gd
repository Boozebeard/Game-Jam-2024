extends Polygon2D

func _ready() -> void:
	var poly := CollisionPolygon2D.new()
	poly.polygon = polygon
	poly.position = position
	$StaticBody2D.add_child(poly)
