extends Node

var utils = preload("res://src/common/utils.gd")

var current_level = 1


func _ready() -> void:
	# [QEUSTION] 単純にduplicateをしただけだとdeep copyできていない？
	Global.draw_grid = Global.LEVEL_1.map(func(x): return x.duplicate())
	set_tile_map()
	$CharacterContainer/Character.init_position(current_level)


func _on_character_moved_cell(x:int, y:int) -> void:
	# ステータス更新
	Global.draw_grid[y][x] = Global.CELL_STATUS.DRAWN
	
	# タイル更新
	$TileMap.set_cell(0, Vector2(x, y), 0, Global.TILE_DRAWN_COORDS)
	
	# クリア判定
	print(utils.is_one_stroke_completed(Global.draw_grid))
	if utils.is_one_stroke_completed(Global.draw_grid):
		$ClearMessage.visible = true


# 現在のLEVEL用にタイルマップを置き換える
func set_tile_map() -> void:
	for y in range(Global.GRID_SIZE):
		for x in range(Global.GRID_SIZE):
			var cell = Global.draw_grid[y][x]
			var tile_coords = Global.TILE_DRAWN_COORDS if cell == Global.CELL_STATUS.DRAWN else Global.TILE_NOT_DRAWN_COORDS
			$TileMap.set_cell(0, Vector2(x, y), 0, tile_coords)


# 操作キャラクターをLEVELの初期位置に配置する
#func init_character_pos() -> void:
#	var pos_zero = Vector2(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)
#	$CharacterContainer/Character.position = pos_zero +  (Global.LEVEL_1_INIT_POS * Global.TILE_SIZE)
