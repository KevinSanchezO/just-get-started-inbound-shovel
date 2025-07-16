extends HBoxContainer
class_name StopWatch

signal start_poisoning()

const LIMIT_MINUTES := 1
const LIMIT_SECONDS := 30

@onready var minutes_label := $Minutes as Label
@onready var seconds_label := $Seconds as Label
@onready var m_seconds_label := $MSeconds as Label

var running := true
var reached_limit := false

var time := 0.0
var minutes := 0.0
var seconds := 0.0
var msec := 0.0


func _ready() -> void:
	self.start_poisoning.connect(_start_poison)


func _start_poison() -> void:
	print("POISON")


func _physics_process(delta: float) -> void:
	if running:
		time += delta


func _process(_delta: float) -> void:
	if running:
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		
		minutes_label.text = "%02d:" % minutes
		seconds_label.text = "%02d:" % seconds
		m_seconds_label.text = "%03d" % msec
	
	if !reached_limit:
		if minutes >= LIMIT_MINUTES and seconds >= LIMIT_SECONDS:
			start_poisoning.emit()
			reached_limit = true 
