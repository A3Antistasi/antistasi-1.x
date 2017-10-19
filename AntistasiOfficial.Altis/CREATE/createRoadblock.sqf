if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_markerPos","_size","_distance","_roads","_connectedRoads","_position","_bunker","_static","_group","_unit","_groupType","_tempGroup","_dog","_normalPos"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_tempGroup = createGroup side_green;

_distance = 20;
while {true} do {
	_roads = _markerPos nearRoads _distance;
	if (count _roads > 1) exitWith {};
	_distance = _distance + 5;
};
_connectedRoads = roadsConnectedto (_roads select 0);

_direction = [_roads select 0, _connectedRoads select 0] call BIS_fnc_DirTo;
if ((isNull (_roads select 0)) OR (isNull (_connectedRoads select 0))) then {diag_log format ["Error in createRoadblock: no suitable roads found near %1",_marker]};

_position = [(_roads select 0), 9, _direction + 270] call BIS_Fnc_relPos;
_bunker = bld_smallBunker createVehicle _position;
_allVehicles pushBack _bunker;
_bunker setDir _direction;
_normalPos = surfaceNormal (position _bunker);
_bunker setVectorUp _normalPos;
_position = getPosATL _bunker;
_static = statMG createVehicle _markerPos;
_allVehicles pushBack _static;
_static setPosATL _position;
_static setDir _direction;
_normalPos = surfaceNormal (position _static);
_static setVectorUp _normalPos;
sleep 1;

_unit = ([_markerPos, 0, infGunner, _tempGroup] call bis_fnc_spawnvehicle) select 0;
_unit moveInGunner _static;

_position = [(_roads select 0), 7, _direction + 90] call BIS_Fnc_relPos;
_bunker = bld_smallBunker createVehicle _position;
_allVehicles pushBack _bunker;
_bunker setDir _direction + 180;
_normalPos = surfaceNormal (position _bunker);
_bunker setVectorUp _normalPos;
_position = getPosATL _bunker;
_static = statMG createVehicle _markerPos;
_allVehicles pushBack _static;
_static setPosATL _position;
_static setDir _direction;
_normalPos = surfaceNormal (position _static);
_static setVectorUp _normalPos;
sleep 1;

_unit = ([_markerPos, 0, infGunner, _tempGroup] call bis_fnc_spawnvehicle) select 0;
_unit moveInGunner _static;

_position = [getPos _bunker, 6, getDir _bunker] call BIS_fnc_relPos;
_static = createVehicle [cFlag, _position, [],0, "CAN_COLLIDE"];
_allVehicles pushBack _static;

{[_x] spawn genVEHinit} forEach _allVehicles;

_groupType = [infAT, side_green] call AS_fnc_pickGroup;
_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
{[_x] join _group} forEach units _tempGroup;
_soldier = ([_markerPos, 0, sol_MED, _group] call bis_fnc_spawnvehicle) select 0;
_soldier = ([_markerPos, 0, sol_LAT, _group] call bis_fnc_spawnvehicle) select 0;
_group selectLeader (units _group select 1);
_group allowFleeing 0;
deleteGroup _tempGroup;

if (random 10 < 2.5) then {
	_dog = _group createUnit ["Fin_random_F",_markerPos,[],0,"FORM"];
	[_dog,_group] spawn guardDog;
};

[leader _group, _marker, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _group;
_allGroups pushBack _group;

waitUntil {sleep 1; !(spawner getVariable _marker) or (count (allUnits select {((side _x == side_green) or (side _x == side_red)) and (_x distance _markerPos <= _size) AND !(captive _x)}) < 1)};

if (count (allUnits select {((side _x == side_green) or (side _x == side_red)) and (_x distance _markerPos <= _size)}) < 1) then {
	[-5,0,_markerPos] remoteExec ["AS_fnc_changeCitySupport",2];
	[["TaskSucceeded", ["", localize "STR_TSK_RB_DESTROYED"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	[_markerPos] remoteExec ["patrolCA",HCattack];
	mrkAAF = mrkAAF - [_marker];
	mrkFIA = mrkFIA + [_marker];
	publicVariable "mrkAAF";
	publicVariable "mrkFIA";
	if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
	[_marker] spawn AS_fnc_respawnRoadblock;
};

waitUntil {sleep 1; !(spawner getVariable _marker)};
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;