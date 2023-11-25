extends Node


# 一筆書きが完了しているか判定する
static func is_one_stroke_completed(grid: Array) -> bool:
	for row in grid:
		for cell in row:
			if cell == Global.CELL_STATUS.NOT_DRAWN:
				return false
	return true


# 指定したLEVELのグリッドを返す
static func get_grid_by_level(level: int) -> Array:
	assert(1 <= level and level <= Global.STAGES.size() , "設定LEVELの範囲外です")
	
	return Global.STAGES[level -1]



# 指定したLEVELの開始位置を返す
static func get_init_position(grid: Array) -> Vector2:
	var x_index = -1
	var y_index = -1
	
	# Global.CELL_STATUS.DRAWNの位置をさがす
	for row in range(grid.size()):
		if Global.CELL_STATUS.DRAWN in grid[row]:
			y_index = row
			x_index = grid[row].find(Global.CELL_STATUS.DRAWN)
			break
	
	assert(x_index != -1 and y_index != -1, "開始位置が設定されていません")

	return Vector2(x_index, y_index)


# セルのステータスから対応するタイルの座標を取得する
static func get_tile_coords_from_status(status: Global.CELL_STATUS)-> Variant:
	if status == Global.CELL_STATUS.DRAWN:
		return Global.TILE_DRAWN_COORDS
	if status == Global.CELL_STATUS.NOT_DRAWN:
		return Global.TILE_NOT_DRAWN_COORDS
	return null

