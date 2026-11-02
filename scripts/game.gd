extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hearts_label: Label = $CanvasLayer/HUD/HeartsLabel
@onready var message_label: Label = $CanvasLayer/HUD/MessageLabel
@onready var flash: ColorRect = $CanvasLayer/HitFlash

const START_POSITION := Vector2(800, 760)
const MAX_LIVES := 3
var lives: int = MAX_LIVES
var respawning: bool = false
var enemy_start_positions: Dictionary = {}

func _ready() -> void:
    player.global_position = START_POSITION
    player.touched_hazard.connect(_on_player_touched_hazard)
    flash.visible = false
    for enemy in get_tree().get_nodes_in_group("arena_enemies"):
        enemy_start_positions[enemy] = enemy.global_position
    _update_hearts()
    message_label.text = "Survis dans l'arène. Évite les ennemis et les pointes."

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
        get_tree().reload_current_scene()

func _on_player_touched_hazard() -> void:
    if respawning:
        return
    respawning = true
    lives -= 1
    _update_hearts()
    player.controls_enabled = false
    player.velocity = Vector2.ZERO
    flash.visible = true

    if lives > 0:
        message_label.text = "Touché ! Retour au départ."
        await get_tree().create_timer(0.35).timeout
        player.global_position = START_POSITION
        _reset_enemies()
        await get_tree().create_timer(0.15).timeout
        flash.visible = false
        player.controls_enabled = true
        message_label.text = "Survis dans l'arène. Il te reste %d cœur(s)." % lives
        respawning = false
    else:
        message_label.text = "Plus de cœurs. La partie recommence..."
        await get_tree().create_timer(0.8).timeout
        get_tree().reload_current_scene()

func _reset_enemies() -> void:
    for enemy in enemy_start_positions.keys():
        if is_instance_valid(enemy):
            enemy.global_position = enemy_start_positions[enemy]
            enemy.velocity = Vector2.ZERO

func _update_hearts() -> void:
    var hearts := ""
    for i in range(MAX_LIVES):
        if i < lives:
            hearts += "♥ "
        else:
            hearts += "♡ "
    hearts_label.text = hearts.strip_edges()
