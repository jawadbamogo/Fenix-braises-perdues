extends Node2D

@export var level_number: int = 1
@export var level_duration: float = 25.0
@export var next_scene_path: String = ""
@export var start_position: Vector2 = Vector2(800, 760)

@onready var player: CharacterBody2D = $Player
@onready var hearts_label: Label = $CanvasLayer/HUD/HeartsLabel
@onready var timer_label: Label = $CanvasLayer/HUD/TimerLabel
@onready var level_label: Label = $CanvasLayer/HUD/LevelLabel
@onready var objective_label: Label = $CanvasLayer/HUD/ObjectiveLabel
@onready var message_label: Label = $CanvasLayer/HUD/MessageLabel
@onready var hit_flash: ColorRect = $CanvasLayer/HitFlash
@onready var transition_panel: Control = $CanvasLayer/TransitionPanel
@onready var transition_title: Label = $CanvasLayer/TransitionPanel/Title
@onready var transition_text: Label = $CanvasLayer/TransitionPanel/Text
@onready var hit_sound: AudioStreamPlayer = $HitSound

var elapsed_level: float = 0.0
var respawning: bool = false
var level_finished: bool = false
var enemy_start_positions: Dictionary = {}

func _ready() -> void:
    GameState.current_level = level_number
    player.global_position = start_position
    player.touched_hazard.connect(_on_player_touched_hazard)
    hit_flash.visible = false
    transition_panel.visible = false
    for enemy in get_tree().get_nodes_in_group("arena_enemies"):
        enemy_start_positions[enemy] = enemy.global_position
    _update_hud()
    message_label.text = "Évite les ennemis et les pointes. Garde tes 3 vies jusqu'au niveau final."

func _process(delta: float) -> void:
    if level_finished:
        return
    elapsed_level += delta
    GameState.total_time += delta
    _update_hud()
    if elapsed_level >= level_duration:
        _finish_level()

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_R:
            GameState.reset_game()
            get_tree().change_scene_to_file("res://scenes/Level1.tscn")

func _on_player_touched_hazard() -> void:
    if respawning or level_finished:
        return
    respawning = true
    GameState.lives -= 1
    _update_hud()
    player.controls_enabled = false
    player.velocity = Vector2.ZERO
    hit_flash.visible = true
    hit_sound.play()

    if GameState.lives <= 0:
        await get_tree().create_timer(0.25).timeout
        get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
        return

    message_label.text = "Touché ! Retour au point de départ."
    await get_tree().create_timer(0.28).timeout
    player.global_position = start_position
    _reset_enemies()
    await get_tree().create_timer(0.15).timeout
    hit_flash.visible = false
    player.controls_enabled = true
    message_label.text = "Continue ! Il te reste %d cœur(s)." % GameState.lives
    respawning = false

func _reset_enemies() -> void:
    for enemy in enemy_start_positions.keys():
        if is_instance_valid(enemy):
            enemy.global_position = enemy_start_positions[enemy]
            enemy.velocity = Vector2.ZERO

func _finish_level() -> void:
    if level_finished:
        return
    level_finished = true
    player.controls_enabled = false
    player.velocity = Vector2.ZERO
    for enemy in get_tree().get_nodes_in_group("arena_enemies"):
        enemy.set_physics_process(false)
    transition_panel.visible = true
    if level_number < 3:
        transition_title.text = "NIVEAU %d TERMINÉ" % level_number
        transition_text.text = "Temps total : %s\nLe prochain niveau t'attend." % _format_time(GameState.total_time)
        await get_tree().create_timer(1.2).timeout
        GameState.current_level = level_number + 1
        get_tree().change_scene_to_file("res://scenes/LevelIntro.tscn")
    else:
        transition_title.text = "DERNIER NIVEAU TERMINÉ"
        transition_text.text = "Tu as survécu aux trois arènes !"
        await get_tree().create_timer(1.4).timeout
        get_tree().change_scene_to_file("res://scenes/Victory.tscn")

func _update_hud() -> void:
    var hearts := ""
    for i in range(GameState.MAX_LIVES):
        hearts += "♥ " if i < GameState.lives else "♡ "
    hearts_label.text = hearts.strip_edges()
    timer_label.text = "Temps total : %s" % _format_time(GameState.total_time)
    level_label.text = "Niveau %d / 3" % level_number
    var remaining: int = maxi(int(ceil(level_duration - elapsed_level)), 0)
    objective_label.text = "Survis encore : %d s" % remaining

func _format_time(value: float) -> String:
    var total_seconds: int = int(value)
    var minutes: int = total_seconds / 60
    var seconds: int = total_seconds % 60
    return "%02d:%02d" % [minutes, seconds]
