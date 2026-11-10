extends Node

const MAX_LIVES: int = 3
var lives: int = MAX_LIVES
var total_time: float = 0.0
var current_level: int = 1

func reset_game() -> void:
    lives = MAX_LIVES
    total_time = 0.0
    current_level = 1

func level_scene_path(level: int) -> String:
    return "res://scenes/Level%d.tscn" % level
