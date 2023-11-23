extends Sprite2D

signal moved_cell(x, y)

var is_moving = false

var position_zero: Vector2
var grid_position = Vector2.ZERO
var position_history = []


func _ready() -> void:
	position_zero = Vector2(texture.get_width() / 2, texture.get_height() / 2)


func _process(delta:float) -> void:
	var move_vector = Vector2.ZERO

	if Input.is_action_pressed("left"):
		move_vector.x -= 1
	if Input.is_action_pressed("right"):
		move_vector.x += 1
	if Input.is_action_pressed("up"):
		move_vector.y -= 1
	if Input.is_action_pressed("down"):
		move_vector.y += 1
	
	# 上下左右一方向のみの移動の場合に処理を実行する
	if move_vector != Vector2.ZERO and !(move_vector.x != 0 and move_vector.y != 0):
		try_move(move_vector)


# 操作キャラクターをLEVELの初期位置に配置する
func init_position(level:int) -> void:
	# TODO: LEVELに合わせた初期位置の設定
	position = position_zero + (Global.LEVEL_1_INIT_POSITION * Global.TILE_SIZE)
	grid_position = Global.LEVEL_1_INIT_POSITION


# 移動判定
func try_move(direction: Vector2) -> void:
	# 移動後の位置
	var new_position = grid_position + direction
	
	# 移動可能か判定する
	if (
		# 移動中か
		is_moving
		# エリア範囲内か
		or new_position.x < 0 or Global.GRID_DIMENSION - 1 < new_position.x
		or new_position.y < 0 or Global.GRID_DIMENSION - 1 < new_position.y 
		# 移動先が移動可能エリアか
		or Global.draw_grid[new_position.y][new_position.x] != Global.CELL_STATUS.NOT_DRAWN
	):
		return
	
	# 移動中に設定する
	is_moving = true
	grid_position = new_position
	
	# 移動先を決定する
	var destination = Vector2(position.x + (direction.x * Global.TILE_SIZE), position.y + (direction.y * Global.TILE_SIZE))
	
	# tweenで移動させる
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", destination, 0.15)
	tween.tween_callback(finish_move)


func finish_move() -> void:
	# 移動可能状態に戻す
	is_moving = false
	
	# 移動後の処理
	moved_cell.emit(grid_position.x, grid_position.y)

