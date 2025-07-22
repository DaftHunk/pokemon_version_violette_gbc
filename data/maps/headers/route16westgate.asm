Route16WestGate_h:
	db GATE ; tileset
	db ROUTE_16_WEST_GATE_HEIGHT, ROUTE_16_WEST_GATE_WIDTH ; dimensions (y, x)
	dw Route16WestGateBlocks, Route16WestGateTextPointers, Route16WestGateScript ; blocks, texts, scripts
	db 0
	dw Route16WestGateObject ; objects
