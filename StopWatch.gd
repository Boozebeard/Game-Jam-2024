extends Label

var time_elapsed := 0.0
# You don't really need this
var counter = 1
var is_stopped = Globals.timer_stopped

func _process(delta: float) -> void:
	is_stopped = Globals.timer_stopped
	
	if !is_stopped:
		time_elapsed += delta
		text = str(time_elapsed).pad_decimals(2)
		Globals.time = time_elapsed

func reset() -> void:
	# possibly save time_elapsed somewhere else before overriding it
	time_elapsed = 0.0
	is_stopped = false
