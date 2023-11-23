extends Sprite2D

signal moved_cell(x, y)

var is_moving = false

var grid_position = Vector2.ZERO
var position_history = []


func _process(delta):
	if Input.is_action_pressed("left"):
		try_move(Vector2.LEFT)
	elif Input.is_action_pressed("right"):
		try_move(Vector2.RIGHT)
	elif Input.is_action_pressed("up"):
		try_move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		try_move(Vector2.DOWN)


# 移動判定
func try_move(direction: Vector2) -> void:
	# 移動可能か
	# 移動中であれば何もしない
	if is_moving:
		return
	
	# 移動後のポジション
	var new_position = grid_position + direction
	# エリア範囲内か
	if (
		new_position.x < 0 or Global.GRID_SIZE - 1 < new_position.x
		or new_position.y < 0 or Global.GRID_SIZE - 1 < new_position.y 
	):
		return
	# 移動先が移動可能エリアか
	if Global.draw_grid[new_position.y][new_position.x] != Global.CELL_STATUS.NOT_DRAWN:
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
	# 移動可能にする
	is_moving = false
	
	# 移動後の処理
	moved_cell.emit(grid_position.x, grid_position.y)
	
