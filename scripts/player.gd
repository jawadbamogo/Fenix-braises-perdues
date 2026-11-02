extends CharacterBody2D

signal touched_hazard

@export var speed: float = 230.0
@export var screen_margin: float = 34.0
var controls_enabled: bool = true
var facing: Vector2 = Vector2.RIGHT

func _ready() -> void:
    add_to_group("player")

func _physics_process(_delta: float) -> void:
    if not controls_enabled:
        velocity = Vector2.ZERO
        move_and_slide()
        return

    var input_vector := Vector2.ZERO
    if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
        input_vector.x -= 1.0
    if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
        input_vector.x += 1.0
    if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
        input_vector.y -= 1.0
    if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
        input_vector.y += 1.0

    input_vector = input_vector.normalized()
    velocity = input_vector * speed
    if input_vector.length() > 0.0:
        facing = input_vector
    move_and_slide()

    # Securite supplementaire : Fenix ne peut jamais sortir de la zone visible.
    # Meme si une collision de mur est ratee, sa position est bloquee dans l'ecran.
    var viewport_size: Vector2 = get_viewport_rect().size
    global_position.x = clampf(global_position.x, screen_margin, viewport_size.x - screen_margin)
    global_position.y = clampf(global_position.y, screen_margin, viewport_size.y - screen_margin)

func hit_by_hazard() -> void:
    emit_signal("touched_hazard")
