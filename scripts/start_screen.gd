extends Control

func _ready() -> void:
    $Center/VBox/StartButton.pressed.connect(_start_game)

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
            _start_game()

func _start_game() -> void:
    GameState.reset_game()
    get_tree().change_scene_to_file("res://scenes/LevelIntro.tscn")
