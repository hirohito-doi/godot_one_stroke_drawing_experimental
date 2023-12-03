extends Sprite2D

var utils = preload("res://src/common/utils.gd")

signal moved_cell(x, y)
signal undo_executed(x, y)


var position_zero: Vector2 # ピクセル単位での(0,0)に相当する位置
var grid_position = Vector2.ZERO # グリッドで見た場合の現在の位置
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
	var init_position = utils.get_init_position(Global.STAGES[level - 1])
	position = position_zero + (init_position * Global.TILE_SIZE)
	grid_position = init_position
	
	# 履歴をクリアする
	position_history = []


# 移動判定
func try_move(direction: Vector2) -> void:
	# 移動後の位置
	var new_position = grid_position + direction
	
	# 移動可能か判定する
	if (
		# 移動受付中か
		Global.can_control == false
		# エリア範囲内か
		or new_position.x < 0 or Global.GRID_DIMENSION - 1 < new_position.x
		or new_position.y < 0 or Global.GRID_DIMENSION - 1 < new_position.y 
		# 移動先が移動可能エリアか
		or Global.draw_grid[new_position.y][new_position.x] != Global.CELL_STATUS.NOT_DRAWN
	):
		return
	
	# コントロール不可にする
	Global.can_control = false
	
	# 現在の位置を退避して、更新する
	var current_position = grid_position
	grid_position = new_position
	
	# 移動先を決定する
	var destination = Vector2(position.x + (direction.x * Global.TILE_SIZE), position.y + (direction.y * Global.TILE_SIZE))
	
	# tweenで移動させる
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", destination, 0.15)
	tween.tween_callback(finish_move)
	
	# 履歴を更新する
	position_history.push_back(current_position)

func finish_move() -> void:
	# コントロール可能状態に戻す
	Global.can_control = true
	
	# 移動後の処理
	moved_cell.emit(grid_position.x, grid_position.y)

# アンドゥを実行する
func undo_move() -> void:
	# 履歴がなければ何もしない
	if position_history.size() == 0:
		return
	
	# コントロール不可にする
	Global.can_control = false
	
	
	# 履歴から移動先を決定する
	var new_position = position_history.pop_back()
	var direction = new_position - grid_position
	
	# 現在の位置を退避して、更新する
	var current_position = grid_position
	grid_position = new_position
	grid_position = new_position
	
	# 移動先を決定する
	var destination = Vector2(position.x + (direction.x * Global.TILE_SIZE), position.y + (direction.y * Global.TILE_SIZE))
	
	# tweenで移動させる
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", destination, 0.1)
	tween.tween_callback(finish_undo)
	
	# アンドゥ実行後の処理
	undo_executed.emit(current_position.x, current_position.y)


func finish_undo() -> void:
	# コントロール可能状態に戻す
	Global.can_control = true
