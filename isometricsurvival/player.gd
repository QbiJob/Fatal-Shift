extends CharacterBody2D  # Или KinematicBody2D для Godot 3.x

# Скорость перемещения персонажа
@export var speed: float = 200.0

# Ссылка на AnimatedSprite2D (укажите правильный путь к узлу)
@onready var animated_sprite = $AnimatedSprite2D
@onready var collison = $CollisionShape2D
# Ссылка на Camera2D
@onready var camera = $Camera2D

# Ограничения зума
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

func _process(delta):
	var direction = Vector2.ZERO

	# Управление движением (WASD или стрелки)
	if Input.is_action_pressed("player_up"):
		direction.y -= 1
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	if Input.is_action_pressed("player_right"):
		direction.x += 1

	# Перемещение персонажа
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()

	# Поворот персонажа к курсору мыши
	look_at(get_global_mouse_position())

func _unhandled_input(event):
	# Проверяем ввод колёсика мыши
	if event is InputEventMouseButton and event.button_index == 4:  # Wheel Up
		zoom_camera(-0.1)
	elif event is InputEventMouseButton and event.button_index == 5:  # Wheel Down
		zoom_camera(0.1)

func zoom_camera(amount: float):
	# Рассчитываем новый масштаб камеры
	var new_zoom = camera.zoom.x + amount
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	camera.zoom = Vector2(new_zoom, new_zoom)
