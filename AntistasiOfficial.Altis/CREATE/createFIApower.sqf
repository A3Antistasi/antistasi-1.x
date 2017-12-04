if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_workers","_markerPos","_flag","_size","_group","_unit","_garrison","_statics","_strength","_counter","_gunnerGroup","_unitType","_spawnPos","_vehicle","_static","_observer"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];
_workers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_statics = staticsToSave select {_x distance _markerPos < (_size max 50)};

if (_marker != "FIA_HQ") then {
	_flag = createVehicle [guer_flag, _markerPos, [],0, "CAN_COLLIDE"];
	_flag allowDamage false;
	_allVehicles pushBack _flag;
	[_flag,"unit"] remoteExec ["AS_fnc_addActionMP"];
	[_flag,"vehicle"] remoteExec ["AS_fnc_addActionMP"];
	// Apex [_flag,"garage"] remoteExec ["AS_fnc_addActionMP"];
};

_gunnerGroup = createGroup side_blue;
_allGroups pushBack _gunnerGroup;
_garrison = garrison getVariable [_marker,[]];
_strength = count _garrison;
_counter = 0;
private _group = grpNull;
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
			_unit = _gunnerGroup createUnit [_unitType, _markerPos, [], 0, "NONE"];
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
				_unit = _gunnerGroup createUnit [_unitType, _markerPos, [], 0, "NONE"];
				_unit moveInGunner _static;
				[_static] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			} else {
				_unit = _gunnerGroup createUnit [_unitType, _markerPos, [], 0, "NONE"];
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

for "_i" from 0 to (count _allGroups) - 1 do {
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

if (_marker != "FIA_HQ") then {
	if !(_marker in destroyedCities) then {
		if ((daytime > 8) AND (daytime < 18)) then {
			_group = createGroup civilian;
			_allGroups pushBack _group;
			for "_i" from 1 to 8 do {
				_unit = _group createUnit [selectRandom CIV_workers, _markerPos, [],0, "NONE"];
				[_unit] spawn CIVinit;
				_workers pushBack _unit;
				sleep 0.5;
			};
			[_marker,_workers] spawn destroyCheck;
			[_group, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOSHARE","DORELAX","NOVEH2"] execVM "scripts\UPSMON.sqf";
		};
	};
};

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
	if (_marker != "FIA_HQ") then {[_marker] remoteExec ["mrkLOOSE",2]};
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

[_allGroups, _allSoldiers + _workers, _allVehicles] spawn AS_fnc_despawnUnits;
if !(isNull _observer) then {deleteVehicle _observer};
