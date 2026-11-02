extends Area2D

var touch_lock: bool = false

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if touch_lock:
        return
    if body.has_method("hit_by_hazard"):
        touch_lock = true
        body.hit_by_hazard()
        await get_tree().create_timer(0.7).timeout
        touch_lock = false
