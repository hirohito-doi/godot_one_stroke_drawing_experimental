extends Node

const TILE_SIZE = 48
const GRID_DIMENSION = 4 # グリッドの1辺の長さ

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
const LEVEL_2 = [
	[1, 1, 1, 1],
	[1, 2, 1, 1],
	[1, 0, 1, 1],
	[1, 1, 1, 1],
]
const STAGES = [LEVEL_1, LEVEL_2]

# 現在のグリッド状態の管理
var draw_grid = []

# キャラクターの操作・コマンドの受付が可能な状態か
var can_control = false
