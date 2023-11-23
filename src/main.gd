extends Node

var utils = preload("res://src/common/utils.gd")


func _ready() -> void:
	# TODO 仮のエリア作成
	for y in range(Global.GRID_SIZE):
		var row = []
		for x in range(Global.GRID_SIZE):
			row.append(Global.CELL_STATUS.NOT_DRAWN)
		Global.draw_grid.append(row)
	Global.draw_grid[0][0] = Global.CELL_STATUS.DRAWN


func _on_character_moved_cell(x:int, y:int) -> void:
	# ステータス更新
	Global.draw_grid[y][x] = Global.CELL_STATUS.DRAWN
	
	# タイル更新
	$TileMap.set_cell(0, Vector2(x, y), 0, Vector2(0, 0))
	
	# クリア判定
	print(utils.is_one_stroke_completed(Global.draw_grid))
	if utils.is_one_stroke_completed(Global.draw_grid):
		$ClearMessage.visible = true
