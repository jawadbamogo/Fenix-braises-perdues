extends CharacterBody2D

@export var speed: float = 95.0
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
    if direction.length() > 4.0:
        velocity = direction.normalized() * speed
    else:
        velocity = Vector2.ZERO
    move_and_slide()

    if direction.length() < 34.0 and not touch_lock:
        touch_lock = true
        if player.has_method("hit_by_hazard"):
            player.hit_by_hazard()
        await get_tree().create_timer(0.6).timeout
        touch_lock = false
