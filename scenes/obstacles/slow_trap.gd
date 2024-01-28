extends Area2D

signal SlowTrapEntered

func _on_body_entered(_body):
	SlowTrapEntered.emit()
