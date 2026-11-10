extends Control

@onready var time_label: Label = $Center/Panel/VBox/TimeLabel

func _ready() -> void:
    time_label.text = "Temps de survie : %s" % _format_time(GameState.total_time)

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE or event.keycode == KEY_R:
            GameState.reset_game()
            get_tree().change_scene_to_file("res://scenes/Level1.tscn")

func _format_time(value: float) -> String:
    var total_seconds: int = int(value)
    return "%02d:%02d" % [total_seconds / 60, total_seconds % 60]
