extends Node

# 一筆書きが完了しているか判定する
static func is_one_stroke_completed(grid: Array) -> bool:
	for row in grid:
		for cell in row:
			if cell == Global.CELL_STATUS.NOT_DRAWN:
				return false
	return true
