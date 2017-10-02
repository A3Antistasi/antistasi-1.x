params ["_origin", ["_dest", "base_4"], ["_spot", false]];
private ["_startRoad","_spawnData","_roadPos","_roadDir"];
_startRoad = _origin;

if ((_spot) && (worldName == "Altis")) exitWith {
	[_origin, "none"] call fnc_getpresetSpawnPos;
};

private _tam = 10;

if !(typeName _origin == "ARRAY") then {
	_startRoad = getMarkerPos _origin;
};
if (worldName == "Altis") then {
	_startRoad = [_origin, "road"] call fnc_getpresetSpawnPos;
};
if !(typeName _dest == "ARRAY") then {
	_dest = getMarkerPos _dest;
};

_spawnData = [_startRoad, _dest] call AS_fnc_findRoadspot;
if (count _spawnData < 1) exitWith {diag_log format ["Error in findSpawnSpots: no suitable roads found near %1",_startRoad]; [_startRoad, [_startRoad, _dest] call BIS_fnc_DirTo]};
_roadPos = _spawnData select 0;
_roadDir = _spawnData select 1;

[_roadPos, _roadDir]