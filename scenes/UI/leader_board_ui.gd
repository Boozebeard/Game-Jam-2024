extends Control

func get_score():
	$MarginContainer/VBoxContainer2/VBoxContainer/Label.text = str(Globals.best_time).pad_decimals(2)
