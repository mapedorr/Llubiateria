extends RichTextLabel

var seconds_passed = 0

var total_time_in_seconds;
var current_time_in_seconds;
var level;

func _ready():
	level = get_parent().get_parent()
	total_time_in_seconds = level.seconds_for_completion

func _process(delta):
	current_time_in_seconds = total_time_in_seconds - seconds_passed
	
	if current_time_in_seconds <= 0:
		current_time_in_seconds = 0
		level.set_state(level.STATES.WON)
		
	set_text("TIEMPO RESTANTE " + str(int(current_time_in_seconds/60))+':'+str(int(current_time_in_seconds%60)))
	
func _on_Timer_timeout():
	seconds_passed += 1
