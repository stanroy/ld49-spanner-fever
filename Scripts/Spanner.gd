extends Area

signal spanner_collected_signal
#
onready var stats_tracker = get_node("../StatsTracker")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("spanner_collected_signal",stats_tracker,"_on_spanner_collected")
	pass



func _on_spanner_area_entered(area):
	if area.get_name() == "CarRoot":
		self.queue_free()
		emit_signal("spanner_collected_signal")
		
		
