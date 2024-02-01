extends TextureProgressBar

@export var player: Player

func _ready():
	player.current_health = 100
	player.health_changed.connect(update_health)
	update_health()

func update_health():
	value = player.current_health * 100 / player.max_health
	
