extends Node

const TILE_SIZE = 48
const GRID_SIZE = 4 # 最大4*4

enum CELL_STATUS {EMPTY, NOT_DRAWN, DRAWN}

# タイルマップ設定
const TILE_DRAWN_COORDS = Vector2(0, 0)
const TILE_NOT_DRAWN_COORDS = Vector2(1, 0)

# レベル設定
const LEVEL_1 = [
	[2, 1, 1, 1],
	[1, 1, 1, 1],
	[1, 1, 1, 1],
	[1, 1, 1, 1],
]
const LEVEL_1_INIT_POSITION = Vector2(0, 0)
const STAGES = [LEVEL_1]

# 現在のグリッド状態の管理
var draw_grid: Array
