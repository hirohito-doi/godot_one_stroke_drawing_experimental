extends Node

var utils = preload("res://src/common/utils.gd")

@export var current_level = 1


func _ready() -> void:
	init_level_setting()


func _process(delta:float) -> void:
	if not Global.can_control:
		return
	
	# アンドゥ
	if Input.is_action_pressed("undo"):
		$CharacterContainer/Character.undo_move()
	# リトライ
	if Input.is_action_pressed("retry"):
		init_level_setting()


# キャラクターの移動が完了した後の処理
func _on_character_moved_cell(x:int, y:int) -> void:
	# ステータス更新
	Global.draw_grid[y][x] = Global.CELL_STATUS.DRAWN
	
	# タイル更新
	$TileMap.set_cell(0, Vector2(x, y), 0, Global.TILE_DRAWN_COORDS)
	
	# クリア判定
	if utils.is_one_stroke_completed(Global.draw_grid):
		$ClearMessage.visible = true
		

# アンドゥが実行された後の処理
func _on_character_undo_executed(x, y) -> void:
	# ステータス更新
	Global.draw_grid[y][x] = Global.CELL_STATUS.NOT_DRAWN
	
	# タイル更新
	$TileMap.set_cell(0, Vector2(x, y), 0, Global.TILE_NOT_DRAWN_COORDS)


# 現在のLEVEL用に各設定をセットする
func init_level_setting() -> void:
	# コマンドの受付を可能にする
	Global.can_control = false
	
	# TODO 設定していないレベルを指定した場合の処理
	var current_grid = utils.get_grid_by_level(current_level)
	
	Global.draw_grid = current_grid.duplicate(true)
	set_tile_map()
	$CharacterContainer/Character.init_position(current_level)
	
	# コマンドの受付を可能にする
	Global.can_control = true


# 現在のLEVEL用にタイルマップを置き換える
func set_tile_map() -> void:
	for y in range(Global.GRID_DIMENSION):
		for x in range(Global.GRID_DIMENSION):
			var cell_status = Global.draw_grid[y][x]
			var tile_coords = utils.get_tile_coords_from_status(cell_status)
			if tile_coords == null:
				$TileMap.erase_cell(0, Vector2(x, y))
			else:
				$TileMap.set_cell(0, Vector2(x, y), 0, tile_coords)


func _on_clear_message_level_up() -> void:
	# 次のLEVELへ進む
	current_level += 1
	$ClearMessage.visible = false
	init_level_setting()
