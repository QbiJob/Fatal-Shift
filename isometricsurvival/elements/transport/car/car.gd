extends Area2D

# Переменные для управления машинкой
@export var max_speed: float = 300.0
@export var acceleration: float = 200.0
@export var friction: float = 100.0
@export var rotation_speed: float = 2.0

var velocity: Vector2 = Vector2.ZERO
var is_player_inside: bool = false
var player = null

# Ссылка на камеру (если она есть у машинки)
@onready var camera = $Camera2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Игрок вошёл в зону машинки
func _on_body_entered(body):
	if body.name == "Player":
		player = body
		print("Игрок рядом с машинкой! Нажми E, чтобы сесть.")

# Игрок вышел из зоны машинки
func _on_body_exited(body):
	if body.name == "Player":
		player = null
		print("Игрок ушёл от машинки.")

# Обработка ввода (например, нажатие E)
func _input(event):
	if event.is_action_pressed("ui_interact") and player:
		if is_player_inside:
			exit_car()
		else:
			enter_car()

# Логика "посадки" в машинку
func enter_car():
	print("Игрок сел в машинку!")
	is_player_inside = true
	player.hide()  # Скрываем игрока
	if camera:
		camera.make_current()  # Переключаем камеру на машинку

# Логика "выхода" из машинки
func exit_car():
	print("Игрок вышел из машинки!")
	is_player_inside = false
	player.show()  # Показываем игрока
	player.global_position = global_position  # Игрок появляется рядом с машинкой
	if camera:
		player.get_node("Camera2D").make_current()  # Переключаем камеру на игрока

# Управление машинкой
func _process(delta):
	if is_player_inside:
		handle_movement(delta)

# Логика движения машинки
func handle_movement(delta):
	var direction = Vector2.ZERO

	# Управление вперёд/назад
	if Input.is_action_pressed("player_up"):
		direction.y -= 1
	if Input.is_action_pressed("player_down"):
		direction.y += 1

	# Управление поворотом
	if Input.is_action_pressed("player_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("player_right"):
		rotation += rotation_speed * delta

	# Применяем ускорение
	if direction != Vector2.ZERO:
		velocity += direction.rotated(rotation) * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		# Применяем трение
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Двигаем машинку
	
