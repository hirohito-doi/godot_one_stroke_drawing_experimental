extends Node

const TILE_SIZE = 48
const GRID_SIZE = 4 # 最大4*4

enum CELL_STATUS {EMPTY, NOT_DRAWN,DRAWN}

var draw_grid: Array
