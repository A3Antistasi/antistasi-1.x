params ["_markerPos", "_roads","_staticType"];
private ["_spawnData","_roadPos","_roadDir","_direction","_position","_bunker","_bunkertype","_static"];

if (typeName _markerPos != "ARRAY") then {
	_markerPos = getMarkerPos _markerPos;
};

_spawnData = [_markerPos, [ciudades, _markerPos] call BIS_fnc_nearestPosition] call AS_fnc_findRoadspot;
if (count _spawnData < 1) exitWith {diag_log format ["Error in spawnBunker: no suitable roads found near %1",_markerPos]};
_roadPos = _spawnData select 0;
_roadDir = _spawnData select 1;

_position = [_roadPos, 7, _roadDir + 270] call BIS_Fnc_relPos;
_bunkertype = ["Land_BagBunker_Small_F","Land_BagBunker_01_small_green_F"] select (worldName == "Tanoa");
_bunker = _bunkertype createVehicle _position;
_bunker setDir _roadDir;
_position = getPosATL _bunker;
_static = _staticType createVehicle _markerPos;
_static setPos _position;
_static setDir _roadDir + 180;
_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
[_unit] spawn genInitBASES;
[_static] spawn genVEHinit;
_unit moveInGunner _static;

[_bunker, _static]