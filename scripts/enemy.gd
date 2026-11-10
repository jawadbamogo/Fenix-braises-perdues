extends CharacterBody2D

@export var speed: float = 78.0
@export var stop_distance: float = 30.0
@export var damage_distance: float = 46.0
var player: Node2D = null
var touch_lock: bool = false

func _ready() -> void:
    add_to_group("arena_enemies")
    player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(_delta: float) -> void:
    if player == null or not is_instance_valid(player):
        player = get_tree().get_first_node_in_group("player") as Node2D
        velocity = Vector2.ZERO
        move_and_slide()
        return

    var direction: Vector2 = player.global_position - global_position
    if direction.length() > stop_distance:
        velocity = direction.normalized() * speed
    else:
        velocity = Vector2.ZERO
    move_and_slide()

    # Le rayon de collision du joueur + celui de l'ennemi vaut environ 32 px.
    # On déclenche légèrement avant/au contact afin que la collision physique ne bloque
    # pas l'ennemi juste hors de la zone de dégâts.
    if direction.length() <= damage_distance and not touch_lock:
        touch_lock = true
        if player.has_method("hit_by_hazard"):
            player.hit_by_hazard()
        await get_tree().create_timer(0.7).timeout
        touch_lock = false
