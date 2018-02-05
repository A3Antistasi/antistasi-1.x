if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allVehicles","_allGroups","_allSoldiers","_markerPos","_position","_size","_reduced","_buildings","_groupGunners","_building","_type","_vehicle","_unit","_flag","_crate","_isFrontline","_vehicleData","_vehCrew","_base","_roads","_data","_strength","_currentStrength","_groupType","_group","_patrolParams","_observer","_radioTower"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_isFrontline = [_marker] call AS_fnc_isFrontline;
_reduced = [false, true] select (_marker in reducedGarrisons);

_buildings = nearestObjects [_markerPos, listMilBld, _size*1.5];

_groupGunners = createGroup side_green;
_allGroups pushBack _groupGunners;

if!(_reduced) then {
	for "_i" from 0 to (count _buildings) - 1 do {
		_building = _buildings select _i;
		_type = typeOf _building;

		call {
			if 	((_type == "Land_Cargo_HQ_V1_F") OR (_type == "Land_Cargo_HQ_V2_F") OR (_type == "Land_Cargo_HQ_V3_F")) exitWith {
				_vehicle = createVehicle [statAA, (_building buildingPos 8), [],0, "CAN_COLLIDE"];
				_vehicle setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _vehicle select 2)];
				_vehicle setDir (getDir _building);
				_vehicle disableTIEquipment true; //Stef disable thermal vision of static guns, AI won't use it and it's just unbalanced if player get it.
				_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
				_unit moveInGunner _vehicle;
				_allVehicles pushBack _vehicle;
				sleep 1;
			};

			if 	((_type == "Land_Cargo_Patrol_V1_F") OR (_type == "Land_Cargo_Patrol_V2_F") OR (_type == "Land_Cargo_Patrol_V3_F")) exitWith {
				_vehicle = createVehicle [statMGtower, (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
				_ang = (getDir _building) - 180;
				_position = [getPosATL _vehicle, 2.5, _ang] call BIS_Fnc_relPos;
				_vehicle setPosATL _position;
				_vehicle setDir (getDir _building) - 180;
				_vehicle disableTIEquipment true; //Stef disable thermal vision of static guns, AI won't use it and it's just unbalanced if player get it.
				_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
				_unit moveInGunner _vehicle;
				_allVehicles pushBack _vehicle;
				sleep 1;
			};

			if 	(_type in listbld) exitWith {
				_vehicle = createVehicle [statMGtower, (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
				_vehicle disableTIEquipment true;
				_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
				_unit moveInGunner _vehicle;
				_allSoldiers = _allSoldiers + [_unit];
				sleep 1;
				_allVehicles = _allVehicles + [_vehicle];
				_vehicle = createVehicle [statMGtower, (_building buildingPos 17), [], 0, "CAN_COLLIDE"];
				_vehicle disableTIEquipment true; //Stef disable thermal vision of static guns, AI won't use it and it's just unbalanced if player get it.
				_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
				_unit moveInGunner _vehicle;
				_allVehicles pushBack _vehicle;
				sleep 1;
			};
		};
	};
};


_flag = createVehicle [cFlag, _markerPos, [],0, "CAN_COLLIDE"];
_flag allowDamage false;
[_flag,"take"] remoteExec ["AS_fnc_addActionMP"];
_allVehicles pushBack _flag;
sleep 0.5;

_crate = "I_supplyCrate_F" createVehicle _markerPos;
_allVehicles pushBack _crate;
sleep 0.5;

if (_marker in puertos) then {
	if !(activeAFRF) then {    //17/10 Stef removing speedboats from RHS
        _position = [_markerPos,_size,_size*3,25,2,0,0] call BIS_Fnc_findSafePos;
        _vehicleData = [_position, 0, (selectRandom vehPatrolBoat), side_green] call bis_fnc_spawnvehicle;
        _vehicle = _vehicleData select 0;
        _vehCrew = _vehicleData select 1;
        _groupVehicle = _vehicleData select 2;

        _beach = [_vehicle,0,200,0,0,90,1] call BIS_Fnc_findSafePos;
        _vehicle setdir ((_vehicle getRelDir _beach) + 180);

        _PP1 = [_position, 100, 200, 25, 2, 45, 0] call BIS_fnc_findSafePos;
        _pWP1 = _groupVehicle addWaypoint [_PP1, 5];
        _pWP1 setWaypointType "MOVE";
        _pWP1 setWaypointBehaviour "AWARE";
        _pWP1 setWaypointSpeed "LIMITED";

        _pWP1 = _groupVehicle addWaypoint [_PP1, 5];
        _pWP1 setWaypointType "CYCLE";
        _pWP1 setWaypointBehaviour "AWARE";
        _pWP1 setWaypointSpeed "LIMITED";

        {
            [_x] spawn genInitBASES;
            _allSoldiers pushBack _x;
        } forEach _vehCrew;
        _allGroups pushBack _groupVehicle;
        _allVehicles pushBack _vehicle;
        sleep 1;
     };
} else {
	_buildings = nearestObjects [_markerPos,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], _size];
	if (count _buildings > 0) then {
		_radioTower = _buildings select 0;

		if ((typeOf _radioTower == "Land_TTowerBig_1_F") OR (typeOf _radioTower == "Land_TTowerBig_2_F")) then {
			private ["_pos","_pos2","_dir"];
			_group = createGroup side_green;
			_pos = getPosATL _radioTower;
			_dir = getDir _radioTower;
			_pos2 = _pos getPos [2,_dir];
			_pos2 set [2,23.1];
			if (typeOf _radioTower == "Land_TTowerBig_2_F") then {
				_pos2 = _pos getPos [1,_dir];
				_pos2 set [2,24.3];
			};
			_unit = _group createUnit [sol_SN, _markerPos, [], _dir, "NONE"];
			_unit setPosATL _pos2;
			_unit forceSpeed 0;
			_unit setUnitPos "UP";
			_allGroups pushBack _group;
		};
	};

	if (_isFrontline) then {
		_base = [bases,_markerPos] call BIS_fnc_nearestPosition;
		if ((_base in mrkFIA) or ((getMarkerPos _base) distance _markerPos > 1000)) then {
			_position = [_markerPos] call mortarPos;
			_vehicle = statMortar createVehicle _position;
			[_vehicle] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
			_unit moveInGunner _vehicle;
			_allVehicles pushBack _vehicle;
			sleep 1;
		};

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
};

_position = _markerPos findEmptyPosition [5,_size,enemyMotorpoolDef];
if !(count _position == 0) then {
	_vehicle = createVehicle [selectRandom vehTrucks, _position, [], 0, "NONE"];
	_vehicle setDir random 360;
	_allVehicles pushBack _vehicle;
	sleep 1;
};

_strength = 1 max (round (_size/50));
_currentStrength = 0;
if (_isFrontline) then {_strength = _strength * 1}; //Stef 27/10 disabled the frontline unit increase untill AI caps is better handled

if (_marker in puestosAA) then {
	_groupType = [infAA, side_green] call AS_fnc_pickGroup;
	_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
	[_group, _marker, "SAFE","SPAWNED","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBack _group;
	sleep 1;
};

while {(spawner getVariable _marker) AND (_currentStrength < _strength)} do {
	if ((_currentStrength == 0)) then {   //Stef removed FPS check, useless for MP, maybe add some extra checks if singleplayer
		_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
		_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
		if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup};
		sleep 1;
		_patrolParams = [_group, _marker, "SAFE","SPAWNED","NOVEH2"]; //Stef removed "NOFOLLOW"
		if (_currentStrength == 0) then {_patrolParams pushBack "FORTIFY"; _patrolParams pushBack "RANDOMUP"};
		_patrolParams execVM "scripts\UPSMON.sqf";
		_allGroups pushBack _group;
		if (_currentStrength == 0) then {
			{_x setUnitPos "MIDDLE"} forEach units _group;
		};
	};
	_currentStrength = _currentStrength + 1;
};

if (_marker in puertos) then {
	_crate addItemCargo ["V_RebreatherIA",round random 5];
	_crate addItemCargo ["G_I_Diving",round random 5];
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

_observer = objNull;
if ((random 100 < (((server getVariable "prestigeNATO") + (server getVariable "prestigeCSAT"))/10)) AND (spawner getVariable _marker)) then {
	_position = [];
	_group = createGroup civilian;
	while {true} do {
		_position = [_markerPos, round (random _size), random 360] call BIS_Fnc_relPos;
		if !(surfaceIsWater _position) exitWith {};
	};
	_observer = _group createUnit [selectRandom CIV_journalists, _position, [],0, "NONE"];
	[_observer] spawn CIVinit;
	_allGroups pushBack _group;
	[_group, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";
};

{
	[_x] spawn genVEHinit
} forEach _allVehicles;

[_marker, _allSoldiers] spawn AS_fnc_garrisonMonitor;

//Despawn Conditions
	waitUntil {sleep 1;
		!(spawner getVariable _marker) OR
		(({!(vehicle _x isKindOf "Air")}
		 	count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits))
			> 3*
			count (allUnits select {(
				(side _x == side_green) OR
				(side _x == side_red)) AND
				(_x distance _markerPos <= (_size max 200)) AND
				!(captive _x)})
		)
	};

if ((spawner getVariable _marker) AND !(_marker in mrkFIA)) then {
	[_flag] remoteExec ["mrkWIN",2];
};

waitUntil {sleep 1; !(spawner getVariable _marker)};

{
	if ((!alive _x) AND !(_x in destroyedBuildings)) then {
		destroyedBuildings = destroyedBuildings + [position _x];
		publicVariableServer "destroyedBuildings";
	};
} forEach _buildings;

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
if !(isNull _observer) then {deleteVehicle _observer};