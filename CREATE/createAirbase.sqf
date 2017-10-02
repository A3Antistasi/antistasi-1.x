if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_markerPos","_size","_isFrontline","_reduced","_allVehicles","_allGroups","_allSoldiers","_patrolMarker","_currentStrength","_spawnPos","_groupType","_group","_dog","_flag","_currentCount","_patrolParams","_crate","_unit","_busy","_buildings","_positionOne","_positionTwo","_vehicle","_vehicleCount","_groupGunners","_roads","_data","_vehicleType","_spawnpool","_observer","_direction","_position"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_isFrontline = [_marker] call AS_fnc_isFrontline;
_reduced = [false, true] select (_marker in reducedGarrisons);
_patrolMarker = [_marker] call AS_fnc_createPatrolMarker;
_busy = if (dateToNumber date > server getVariable _marker) then {false} else {true};

_groupGunners = createGroup side_green;
if ((spawner getVariable _marker) AND (_isFrontline)) then {
	_roads = _markerPos nearRoads _size;
	if (count _roads != 0) then {
		_data = [_markerPos, _roads, statAT] call AS_fnc_spawnBunker;
		_allVehicles pushBack (_data select 0);
		_vehicle = (_data select 1);
		_allVehicles pushBack _vehicle;
		_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
		_unit moveInGunner _vehicle;
	};
};

_currentCount = 0;
while {(spawner getVariable _marker) AND (_currentCount < 4)} do {
	while {true} do {
		_spawnPos = [_markerPos, 150 + (random 350) ,random 360] call BIS_fnc_relPos;
		if (!surfaceIsWater _spawnPos) exitWith {};
	};
	_groupType = [infPatrol, side_green] call AS_fnc_pickGroup;
	_group = [_spawnPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
	sleep 1;
	if (random 10 < 2.5) then {
		_dog = _group createUnit ["Fin_random_F",_spawnPos,[],0,"FORM"];
		[_dog] spawn guardDog;
	};
	[leader _group, _patrolMarker, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBack _group;
	_currentCount = _currentCount +1;
};

if !(_busy) then {
	_buildings = nearestObjects [_markerPos, ["Land_LandMark_F"], _size / 2];
	if (count _buildings > 1) then {
		_positionOne = getPos (_buildings select 0);
		_positionTwo = getPos (_buildings select 1);
		_direction = [_positionOne, _positionTwo] call BIS_fnc_DirTo;
		_position = [_positionOne, 5,_direction] call BIS_fnc_relPos;
		_group = createGroup side_green;

		_currentCount = 0;
		while {(spawner getVariable _marker) AND (_currentCount < 5)} do {
			_vehicleType = indAirForce call BIS_fnc_selectRandom;
			_vehicle = createVehicle [_vehicleType, _position, [],3, "NONE"];
			_vehicle setDir (_direction + 90);
			sleep 1;
			_allVehicles pushBack _vehicle;
			_position = [_position, 20,_direction] call BIS_fnc_relPos;
			_unit = ([_markerPos, 0, infPilot, _group] call bis_fnc_spawnvehicle) select 0;
			_currentCount = _currentCount + 1;
		};

		[leader _group, _marker, "SAFE","SPAWNED","NOFOLLOW","NOVEH"] execVM "scripts\UPSMON.sqf";
	};
	_allGroups pushBack _group;
};

_flag = createVehicle [cFlag, _markerPos, [],0, "CAN_COLLIDE"];
_flag allowDamage false;
[_flag,"take"] remoteExec ["AS_fnc_addActionMP"];
_allVehicles pushBack _flag;

_crate = "I_supplyCrate_F" createVehicle _markerPos;
_allVehicles pushBack _crate;

_arrayVeh = vehPatrol + vehSupply + enemyMotorpool - [heli_default];
_vehicleCount = round (_size/60);
_currentCount = 0;
while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
	if (diag_fps > minimoFPS) then {
		_vehicleType = _arrayVeh call BIS_fnc_selectRandom;
		_position = [_markerPos, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		_vehicle = createVehicle [_vehicleType, _position, [], 0, "NONE"];
		_vehicle setDir random 360;
		_allVehicles pushBack _vehicle;
	};
	sleep 1;
	_currentCount = _currentCount + 1;
};

_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup};
sleep 1;
[leader _group, _marker, "SAFE", "RANDOMUP","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
_allGroups pushBack _group;

_currentCount = 0;
if (_isFrontline) then {_vehicleCount = _vehicleCount * 2};
_vehicleCount = round(0.3*_vehicleCount); //Lower the amount of infantry squads
while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
	if (diag_fps > minimoFPS) then {
		while {true} do {
			_spawnPos = [_markerPos, 15 + (random _size),random 360] call BIS_fnc_relPos;
			if (!surfaceIsWater _spawnPos) exitWith {};
		};
		_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
		_group = [_spawnPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
		if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup};
		sleep 1;
		[leader _group, _marker, "SAFE","SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
		_allGroups pushBack _group;
	};
	sleep 1;
	_currentCount = _currentCount + 1;
};

{[_x] spawn genVEHinit} forEach _allVehicles;

sleep 3;

{
	_group = _x;
	if (_reduced) then {[_group] call AS_fnc_adjustGroupSize};
	{
		if (alive _x) then {
			[_x] spawn genInitBASES;
			_allSoldiers pushBackUnique _x;
		};
	} forEach units _group;
} forEach _allGroups;

[_marker, _allSoldiers] spawn AS_fnc_garrisonMonitor;

_group = createGroup civilian;
_allGroups pushBack _group;
_dog = _group createUnit ["Fin_random_F",_markerPos,[],0,"FORM"];
[_dog] spawn guardDog;
_allSoldiers pushBack _dog;

_observer = objNull;
if ((random 100 < (((server getVariable "prestigeNATO") + (server getVariable "prestigeCSAT"))/10)) AND (spawner getVariable _marker)) then {
	_spawnPos = [];
	_group = createGroup civilian;
	while {true} do {
		_spawnPos = [_markerPos, round (random _size), random 360] call BIS_Fnc_relPos;
		if !(surfaceIsWater _spawnPos) exitWith {};
	};
	_observer = _group createUnit [selectRandom CIV_journalists, _spawnPos, [],0, "NONE"];
	[_observer] spawn CIVinit;
	_allGroups pushBack _group;
	[_observer, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";
};

waitUntil {sleep 1; !(spawner getVariable _marker) OR (({!(vehicle _x isKindOf "Air")} count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits)) > 3*count (allUnits select {((side _x == side_green) OR (side _x == side_red)) AND (_x distance _markerPos <= (_size max 300)) AND !(captive _x)}))};

if ((spawner getVariable _marker) AND !(_marker in mrkFIA)) then {
	[_flag] remoteExec ["mrkWIN",2];
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

deleteMarker _patrolMarker;
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
if !(isNull _observer) then {deleteVehicle _observer};