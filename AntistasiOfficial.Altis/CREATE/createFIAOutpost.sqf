if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_markerPos","_spawnPos","_size","_statics","_buildings","_groupGunners","_building","_type","_vehicle","_unit","_flag","_direction","_antenna","_garrison","_strength","_counter","_observer","_group"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_isFrontline = [_marker] call AS_fnc_isFrontline;

_buildings = nearestObjects [_markerPos, listMilBld, _size*1.5];
_statics = staticsToSave select {_x distance _markerPos < (_size max 50)};

_groupGunners = createGroup side_blue; //side_green; //What the hell was this? Sparker.
_allGroups pushBack _groupGunners;
for "_i" from 0 to (count _buildings) - 1 do {
	_building = _buildings select _i;
	_type = typeOf _building;
	call {
		if 	((_type == "Land_Cargo_HQ_V1_F") OR (_type == "Land_Cargo_HQ_V2_F") OR (_type == "Land_Cargo_HQ_V3_F")) exitWith {
			_vehicle = createVehicle [guer_stat_AA, (_building buildingPos 8), [],0, "CAN_COLLIDE"];
			_vehicle setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _vehicle select 2)];
			_vehicle setDir (getDir _building);
			_unit = _groupGunners createUnit [guer_sol_AR, _markerPos, [], 0, "NONE"];
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

		if 	((_type == "Land_Cargo_Patrol_V1_F") or (_type == "Land_Cargo_Patrol_V2_F") or (_type == "Land_Cargo_Patrol_V3_F")) exitWith {
			_vehicle = createVehicle [guer_stat_MGH, (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
			_direction = (getDir _building) - 180;
			_spawnPos = [getPosATL _vehicle, 2.5, _direction] call BIS_Fnc_relPos;
			_vehicle setPosATL _spawnPos;
			_vehicle setDir (getDir _building) - 180;
			_unit = _groupGunners createUnit [guer_sol_AR, _markerPos, [], 0, "NONE"];
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

		if 	(_type in listbld) then {
			_vehicle = createVehicle [guer_stat_MGH, (_building buildingPos 11), [], 0, "CAN_COLLIDE"];
			_unit = _groupGunners createUnit [guer_sol_AR, _markerPos, [], 0, "NONE"];
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
			_vehicle = createVehicle [guer_stat_MGH, (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
			_unit = _groupGunners createUnit [guer_sol_AR, _markerPos, [], 0, "NONE"];
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};
	};
};

_flag = createVehicle [guer_flag, _markerPos, [],0, "CAN_COLLIDE"];
_flag allowDamage false;
_allVehicles pushBack _flag;
[_flag,"unit"] remoteExec ["AS_fnc_addActionMP"];
[_flag,"vehicle"] remoteExec ["AS_fnc_addActionMP"];
// Apex [_flag,"garage"] remoteExec ["AS_fnc_addActionMP"];

if (_marker in puertos) then {
	[_flag,"seaport"] remoteExec ["AS_fnc_addActionMP"];
};

_antenna = [antenas,_markerPos] call BIS_fnc_nearestPosition;
if (getPos _antenna distance _markerPos < 100) then {
	[_flag,"jam"] remoteExec ["AS_fnc_addActionMP"];
};

_garrison = garrison getVariable [_marker,[]];
_strength = count _garrison;
_counter = 0;
_group = grpNull;
while {(spawner getVariable _marker) AND (_counter < _strength)} do {
    if (isNull _group) then {
        _group = createGroup side_blue;
        _allGroups pushBack _group;
        while {true} do {
            _spawnPos = [_markerPos, random _size,random 360] call BIS_fnc_relPos;
            if (!surfaceIsWater _spawnPos) exitWith {};
        };
    };
	_unitType = _garrison select _counter;
	call {
		if (_unitType == guer_sol_UN) exitWith {
			_unit = _groupGunners createUnit [_unitType, _markerPos, [], 0, "NONE"];
			_spawnPos = [_markerPos] call mortarPos;
			_vehicle = guer_stat_mortar createVehicle _spawnPos;
			_allVehicles pushBack _vehicle;
			[_vehicle] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			_unit assignAsGunner _vehicle;
			_unit moveInGunner _vehicle;
		};

		if ((_unitType == guer_sol_RFL) AND (count _statics > 0)) exitWith {
			_static = _statics select 0;
			if (typeOf _static == guer_stat_mortar) then {
				_unit = _groupGunners createUnit [_unitType, _markerPos, [], 0, "NONE"];
				_unit moveInGunner _static;
				[_static] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			} else {
				_unit = _groupGunners createUnit [_unitType, _markerPos, [], 0, "NONE"];
				_unit moveInGunner _static;
			};
			_statics = _statics - [_static];
		};

		_unit = _group createUnit [_unitType, _markerPos, [], 0, "NONE"];
		if (_unitType == guer_sol_SL) then {_group selectLeader _unit};
	};

	_counter = _counter + 1;
    if(count units _group == 4) then {_group = grpNull;};
};

for "_i" from 0 to (count _allGroups) - 1 do {   //Stef 02/10 check here for adapting mobility
	_group = _allGroups select _i;
	if (_i == 0) then {
		[_group, _marker, "SAFE","SPAWNED","RANDOMUP","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	} else {
		[_group, _marker, "SAFE","SPAWNED","RANDOM","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	};
};

{
	[_x] spawn VEHinit;
} forEach _allVehicles;

{
	_group = _x;
	{
		[_x, _marker] spawn AS_fnc_initialiseFIAGarrisonUnit;
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups;

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
	[_group, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";
};

waitUntil {sleep 1; !(spawner getVariable _marker) OR (({!(vehicle _x isKindOf "Air")} count ([_size,0,_markerPos,"OPFORSpawn"] call distanceUnits)) > 3*(({alive _x} count _allSoldiers) + count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits)))};

if (spawner getVariable _marker) then {
	[_marker] remoteExec ["mrkLOOSE",2];
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

{if ((!alive _x) AND !(_x in destroyedBuildings)) then {destroyedBuildings = destroyedBuildings + [position _x]; publicVariableServer "destroyedBuildings"}} forEach _buildings;

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
if !(isNull _observer) then {deleteVehicle _observer};