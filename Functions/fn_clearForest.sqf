if (player != slowhand) exitWith {hint "Only Commanders can order to clear the forest"};

if (!isMultiplayer) then {
	{
		_x hideObject true;
	} foreach (nearestTerrainObjects [getMarkerPos guer_respawn,["tree","bush"],20]);
} else {
	{
		[_x,true] remoteExec ["hideObjectGlobal",2];
	} foreach (nearestTerrainObjects [getMarkerPos guer_respawn,["tree","bush"],20])
};

hint localize "STR_HINTS_CLEARED_FOREST";
flag_chopForest = true; publicVariable "flag_chopForest";