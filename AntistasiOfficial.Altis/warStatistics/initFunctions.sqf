ws_fnc_newGridArray = compile preprocessFileLineNumbers "warStatistics\fn_newGridArray.sqf";
ws_fnc_copyGrid = compile preprocessFileLineNumbers "warStatistics\fn_copyGrid.sqf";
ws_fnc_plotGrid = compile preprocessFileLineNumbers "warStatistics\fn_plotGrid.sqf";
ws_fnc_plotDirGrid = compile preprocessFileLineNumbers "warStatistics\fn_plotDirGrid.sqf";
ws_fnc_unplotGrid = compile preprocessFileLineNumbers "warStatistics\fn_unplotGrid.sqf";
ws_fnc_markersToGridArray = compile preprocessFileLineNumbers "warStatistics\fn_markersToGridArray.sqf";
ws_fnc_addGrid = compile preprocessFileLineNumbers "warStatistics\fn_addGrid.sqf";
ws_fnc_subGrid = compile preprocessFileLineNumbers "warStatistics\fn_subGrid.sqf";

//Get value
ws_fnc_getValue = compile preprocessFileLineNumbers "warStatistics\fn_getValue.sqf";
ws_fnc_getValueID = compile preprocessFileLineNumbers "warStatistics\fn_getValueID.sqf";
ws_fnc_getSmoothValueID = compile preprocessFileLineNumbers "warStatistics\fn_getSmoothValueID.sqf";
ws_fnc_getEdgeValueID = compile preprocessFileLineNumbers "warStatistics\fn_getEdgeValueID.sqf";
ws_fnc_getEdgeDirID = compile preprocessFileLineNumbers "warStatistics\fn_getEdgeDirID.sqf";
ws_fnc_getZeroCrossingValueID = compile preprocessFileLineNumbers "warStatistics\fn_getZeroCrossingValueID.sqf";

//Set value
ws_fnc_setValue = compile preprocessFileLineNumbers "warStatistics\fn_setValue.sqf";
ws_fnc_setValueID = compile preprocessFileLineNumbers "warStatistics\fn_setValueID.sqf";
ws_fnc_setValueAll = compile preprocessFileLineNumbers "warStatistics\fn_setValueAll.sqf";

//Change value
ws_fnc_addValue = compile preprocessFileLineNumbers "warStatistics\fn_addValue.sqf";
ws_fnc_addValueID = compile preprocessFileLineNumbers "warStatistics\fn_addValueID.sqf";

//Filtering functions
ws_fnc_filterEdge = compile preprocessFileLineNumbers "warStatistics\fn_filterEdge.sqf";
ws_fnc_filterEdgeDir = compile preprocessFileLineNumbers "warStatistics\fn_filterEdgeDir.sqf";
ws_fnc_filterSmooth = compile preprocessFileLineNumbers "warStatistics\fn_filterSmooth.sqf";
ws_fnc_filterZeroCrossing = compile preprocessFileLineNumbers "warStatistics\fn_filterZeroCrossing.sqf";
ws_fnc_filterThreshold = compile preprocessFileLineNumbers "warStatistics\fn_filterThreshold.sqf";

//Functions related with roads
ws_fnc_getRandomPosOnRoad = compile preprocessFileLineNumbers "warStatistics\fn_getRandomPosOnRoad.sqf";
ws_fnc_getRoadWidth = compile preprocessFileLineNumbers "WarStatistics\fn_getRoadWidth.sqf";
ws_fnc_getRoadLength = compile preprocessFileLineNumbers "WarStatistics\fn_getRoadLength.sqf";
ws_fnc_findRoadblockRoads = compile preprocessFileLineNumbers "WarStatistics\fn_findRoadblockRoads.sqf";
ws_fnc_findRoadblockPos = compile preprocessFileLineNumbers "WarStatistics\fn_findRoadblockPos.sqf";
ws_fnc_putRoadblockMarkersAtFrontline = compile preprocessFileLineNumbers "WarStatistics\fn_putRoadblockMarkersAtFrontline.sqf";
ws_fnc_sortRoadsByWidth = compile preprocessFileLineNumbers "WarStatistics\fn_sortRoadsByWidth.sqf";