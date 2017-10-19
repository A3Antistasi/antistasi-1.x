if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_markerPos","_size","_isFrontline","_reduced","_allVehicles","_allGroups","_allSoldiers","_patrolMarker","_currentStrength","_spawnPos","_groupType","_group","_dog","_flag","_currentCount","_patrolParams","_crate","_unit","_busy","_buildings","_building","_buildingType","_vehicle","_vehicleCount","_groupGunners","_roads","_data","_vehicleType","_spawnpool","_observer"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_isFrontline = [_marker] call AS_fnc_isFrontline;
_reduced = [false, true] select (_marker in reducedGarrisons);
_patrolMarker = [_marker] call AS_fnc_createPatrolMarker;
_busy = if (dateToNumber date > server getVariable _marker) then {false} else {true};

_buildings = nearestObjects [_markerPos, listMilBld, _size*1.5];
_groupGunners = createGroup side_green;

for "_i" from 0 to (count _buildings) - 1 do {
	_building = _buildings select _i;
	_buildingType = typeOf _building;

	call {
		if 	((_buildingType == "Land_Cargo_HQ_V1_F") OR (_buildingType == "Land_Cargo_HQ_V2_F") OR (_buildingType == "Land_Cargo_HQ_V3_F")) exitWith {
			_vehicle = createVehicle [statAA, (_building buildingPos 8), [],0, "CAN_COLLIDE"];
			_vehicle setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _vehicle select 2)];
			_vehicle setDir (getDir _building);
			_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

		if 	((_buildingType == "Land_Cargo_Patrol_V1_F") OR (_buildingType == "Land_Cargo_Patrol_V2_F") OR (_buildingType == "Land_Cargo_Patrol_V3_F")) exitWith {
			_vehicle = createVehicle [statMGtower, (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
			_position = [getPosATL _vehicle, 2.5, (getDir _building) - 180] call BIS_Fnc_relPos;
			_vehicle setPosATL _position;
			_vehicle setDir (getDir _building) - 180;
			_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

		if ((_buildingType == "Land_HelipadSquare_F") AND (!_isFrontline)) exitWith {
			_vehicle = createVehicle [selectRandom heli_unarmed, position _building, [],0, "CAN_COLLIDE"];
			_vehicle setDir (getDir _building);
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

		if 	(_buildingType in listbld) exitWith {
			_vehicle = createVehicle [statMGtower, (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
			_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
			_unit moveInGunner _vehicle;
			_allSoldiers = _allSoldiers + [_unit];
			sleep 1;
			_allVehicles = _allVehicles + [_vehicle];
			_vehicle = createVehicle [statMGtower, (_building buildingPos 17), [], 0, "CAN_COLLIDE"];
			_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};
	};
};

_flag = createVehicle [cFlag, _markerPos, [],0, "CAN_COLLIDE"];
_flag allowDamage false;
[_flag,"take"] remoteExec ["AS_fnc_addActionMP"];
_allVehicles pushBack _flag;

_crate = "I_supplyCrate_F" createVehicle _markerPos;
_allVehicles pushBack _crate;

_vehicleCount = 4 min (round (_size / 30));
if ( _vehicleCount > 0 ) then {
	_spawnPos = [_markerPos, random (_size / 2),random 360] call BIS_fnc_relPos;
	_currentCount = 0;
	while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
		_spawnPos = [_markerPos] call mortarPos;
		_vehicle = statMortar createVehicle _spawnPos;
		[_vehicle] execVM "scripts\UPSMON\MON_artillery_add.sqf";
		_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
		_unit moveInGunner _vehicle;
		_allVehicles pushBack _vehicle;
		sleep 1;
		_currentCount = _currentCount + 1;
	};
};

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

_allGroups pushBack _groupGunners;

if (!_busy) then {
	_spawnpool = vehAPC + vehPatrol + enemyMotorpool - [heli_default];
	_vehicleCount = 1 max (round (_size/30));
	_spawnPos = _markerPos;
	_currentCount = 0;
	while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
		if (diag_fps > minimoFPS) then {
			_vehicleType = selectRandom _spawnpool;
			_spawnPos = [_spawnPos findEmptyPosition [10,60,_vehicleType], [_markerPos, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos] select (_size > 40);
			_vehicle = createVehicle [_vehicleType, _spawnPos, [], 0, "NONE"];
			_vehicle setDir random 360;
			_allVehicles pushBack _vehicle;
		};
		sleep 1;
		_currentCount = _currentCount + 1;
	};
};

{[_x] spawn genVEHinit} forEach _allVehicles;

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

_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup};
sleep 1;
[leader _group, _marker, "SAFE", "RANDOMUP","SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
_allGroups pushBack _group;
{_x setUnitPos "MIDDLE";} forEach units _group;

_currentCount = 0;
if (_isFrontline) then {_vehicleCount = _vehicleCount * 2};
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

if ((spawner getVariable _marker) AND !(_marker in mrkFIA)) then{
	[_flag] remoteExec ["mrkWIN",2];
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

{
	if ((!alive _x) AND !(_x in destroyedBuildings)) then {
		destroyedBuildings = destroyedBuildings + [position _x];
		publicVariableServer "destroyedBuildings";
	};
} forEach _buildings;

deleteMarker _patrolMarker;
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
if !(isNull _observer) then {deleteVehicle _observer};