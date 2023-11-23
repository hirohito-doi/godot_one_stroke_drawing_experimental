extends Node

var utils = preload("res://src/common/utils.gd")

var current_level = 1


func _ready() -> void:
	Global.draw_grid = Global.LEVEL_1.duplicate(true)
	set_tile_map()
	$CharacterContainer/Character.init_position(current_level)


func _on_character_moved_cell(x:int, y:int) -> void:
	# ステータス更新
	Global.draw_grid[y][x] = Global.CELL_STATUS.DRAWN
	
	# タイル更新
	$TileMap.set_cell(0, Vector2(x, y), 0, Global.TILE_DRAWN_COORDS)
	
	# クリア判定
	if utils.is_one_stroke_completed(Global.draw_grid):
		$ClearMessage.visible = true


# 現在のLEVEL用にタイルマップを置き換える
func set_tile_map() -> void:
	for y in range(Global.GRID_DIMENSION):
		for x in range(Global.GRID_DIMENSION):
			var cell = Global.draw_grid[y][x]
			var tile_coords = Global.TILE_DRAWN_COORDS if cell == Global.CELL_STATUS.DRAWN else Global.TILE_NOT_DRAWN_COORDS
			$TileMap.set_cell(0, Vector2(x, y), 0, tile_coords)
