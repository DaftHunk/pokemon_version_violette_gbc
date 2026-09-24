Route22GateUpstairs_h:
	db GATE ; tileset
	db ROUTE_22_GATE_UPSTAIRS_HEIGHT, ROUTE_22_GATE_UPSTAIRS_WIDTH ; dimensions (y, x)
	dw Route22GateUpstairsBlocks, Route22GateUpstairsTextPointers, Route22GateUpstairsScript ; blocks, texts, scripts
	db 0 ; connections
	dw Route22GateUpstairsObject ; objects
