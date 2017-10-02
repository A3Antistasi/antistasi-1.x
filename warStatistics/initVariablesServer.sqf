//Initialize global server variables and grids. Execute after initFunctions.sqf

ws_territory		= call ws_fnc_newGridArray;	//Territories, >0 means AAF, <0 means FIA
ws_frontlineSmooth	= call ws_fnc_newGridArray;	//Smooth frontline
ws_frontline		= call ws_fnc_newGridArray;	//Frontline
ws_frontlineDir		= call ws_fnc_newGridArray;	//Frontline direction