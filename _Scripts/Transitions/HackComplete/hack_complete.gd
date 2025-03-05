extends Node

var level: Level

signal button_pressed

func _ready() -> void:
	self.visible = false

func initialise() -> void:
	level = self.get_parent()
