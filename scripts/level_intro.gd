extends Control

@onready var title_label: Label = $Center/VBox/Title
@onready var description_label: Label = $Center/VBox/Description
@onready var ready_label: Label = $Center/VBox/Ready
@onready var start_button: Button = $Center/VBox/StartButton

func _ready() -> void:
    var level := clampi(GameState.current_level, 1, 3)
    title_label.text = "NIVEAU %d" % level
    if level == 1:
        description_label.text = "BRAISES CALMES\nDécouvre l'arène, évite les pointes et garde tes 3 cœurs."
    elif level == 2:
        description_label.text = "COULOIRS DE CENDRES\nLes ennemis accélèrent et l'environnement devient plus fermé."
    else:
        description_label.text = "FOURNAISE FINALE\nDernière arène : ennemis rapides, passages plus serrés et survie maximale."
    ready_label.text = "PRÊT ?"
    start_button.text = "COMMENCER LE NIVEAU %d" % level
    start_button.pressed.connect(_start_level)

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
            _start_level()

func _start_level() -> void:
    get_tree().change_scene_to_file(GameState.level_scene_path(GameState.current_level))
