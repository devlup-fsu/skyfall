extends Node3D

signal hit

@onready var s_impact = preload("res://525101__jomse__plasticimpactb3.wav")

var objects = ['beachball', 'box', 'lamp', 'wheel']
var res_format_string = "res://objects/%s.tscn"
var object: RigidBody3D
var kill = true
var impacted = false

func _ready():
	var scene = load(res_format_string % (objects[randi() % objects.size()])) # ", objects[randi() % objects.size()] ,"
	object = scene.instantiate()
	object.contact_monitor = true
	object.max_contacts_reported = 5
	object.scale *= 0.01
	add_child(object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var bodies = object.get_colliding_bodies()
	for body in bodies:
		if not impacted:
			$AudioStreamPlayer3D.play()
			impacted = true
		if body is Player and kill:
			hit.emit()
		else:
			kill = false

