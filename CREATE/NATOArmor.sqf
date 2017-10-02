if (!isServer and hasInterface) exitWith {};

params ["_originMarker","_targetMarker"];
private ["_originPos","_targetPosition","_originName","_targetName","_endTime","_counter","_group","_wp0","_tsk","_spawnpositionData","_spawnPosition","_direction","_vehicleData","_vehicle","_vehicleCrew"];

[[],[]] params ["_allVehicles","_allSoldiers"];

#define duration 60

_originPos = getMarkerPos _originMarker;
_targetPosition = getMarkerPos _targetMarker;

_targetName = [_targetMarker] call AS_fnc_localizar;
_originName = [_originMarker] call AS_fnc_localizar;
duration = 60;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + duration];
_endTime = dateToNumber _endTime;

_tsk = ["NATOArmor",[side_blue,civilian],[format [localize "STR_TSK_NATO_ARMOR",_targetName,_originName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4, A3_Str_BLUE],format ["%1 Armor", A3_Str_BLUE],_targetMarker],_targetPosition,"CREATED",5,true,true,"Attack"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_counter = server getVariable ["prestigeNATO",0];
_counter = round (_counter / 25);
[-20,0] remoteExec ["prestige",2];

_group = createGroup side_blue;
_group setVariable ["esNATO",true,true];

_wp0 = _group addWaypoint [_targetPosition, 0];
_wp0 setWaypointType "SAD";
_wp0 setWaypointBehaviour "SAFE";
_wp0 setWaypointSpeed "LIMITED";
_wp0 setWaypointFormation "COLUMN";

//_spawnpositionData = [_originPosition, _targetPosition] call AS_fnc_findSpawnSpots; //originPosition is unknown! Sparker.
_spawnpositionData = [_originPos, _targetPosition] call AS_fnc_findSpawnSpots;
_spawnPosition = _spawnpositionData select 0;
_direction = _spawnpositionData select 1;


for "_i" from 1 to _counter do {
	_vehicleData = [_spawnPosition, _direction, selectRandom bluMBT, _group] call bis_fnc_spawnvehicle;
	_vehicle = _vehicleData select 0;
	[_vehicle] spawn NATOVEHinit;
	[_vehicle,"NATO Armor"] spawn inmuneConvoy;
	_vehicleCrew = _vehicleData select 1;
	{[_x] spawn NATOinitCA; _allSoldiers pushBack _x} forEach _vehicleCrew;
	_allVehicles pushBack _vehicle;
	_vehicle allowCrewInImmobile true;
	sleep 15;
};

waitUntil {sleep 10; (dateToNumber date > _endTime) OR ({alive _x} count _allSoldiers == 0) OR ({(alive _x)} count _allVehicles == 0)};

if (({alive _x} count _allSoldiers == 0) OR ({(alive _x)} count _allVehicles == 0)) then {
	_tsk = ["NATOArmor",[side_blue,civilian],[format [localize "STR_TSK_NATO_ARMOR",_targetName,_originName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4, A3_Str_BLUE],format ["%1 Armor", A3_Str_BLUE],_targetMarker],_targetPosition,"FAILED",5,true,true,"Attack"] call BIS_fnc_setTask;
	[-10,0] remoteExec ["prestige",2];
};

sleep 15;

[0,_tsk] spawn borrarTask;

[[_group], _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;