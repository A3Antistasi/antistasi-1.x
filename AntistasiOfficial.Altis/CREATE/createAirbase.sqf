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
_buildings = nearestObjects [_markerPos, listMilBld, _size*1.5];


//Adding statics to garrison buildings
	if(!_reduced) then {
			for "_i" from 0 to (count _buildings) - 1 do {
				_building = _buildings select _i;
				_buildingType = typeOf _building;

				call {
					//Stef defensive vehicle with gunner on.
					if 	((_buildingType == "Land_HelipadCivil_F") and !(_reduced)) exitWith {
						_vehicle = createVehicle [selectRandom vehDef, position _building, [],0, "CAN_COLLIDE"];
						_vehicle setDir (getDir _building);
						_vehicle setCenterOfMass [(getCenterOfMass _vehicle) vectorAdd [0, 0, -1], 0];
						_unit = ([_markerPos, 0, infCrew, _groupGunners] call bis_fnc_spawnvehicle) select 0;
						_unit moveInGunner _vehicle;
						_allVehicles pushBack _vehicle;
						_allsoldiers pushBack _unit;
						sleep 0.1;
					};

					if 	((_buildingType == "Land_Cargo_HQ_V1_F") OR (_buildingType == "Land_Cargo_HQ_V2_F") OR (_buildingType == "Land_Cargo_HQ_V3_F")) exitWith {
						_vehicle = createVehicle [statAA, (_building buildingPos 8), [],0, "CAN_COLLIDE"];
						_vehicle setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _vehicle select 2)];
						_vehicle setDir (getDir _building);
						_vehicle setCenterOfMass [(getCenterOfMass _vehicle) vectorAdd [0, 0, -1], 0];
						_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
						_unit moveInGunner _vehicle;
						_allVehicles pushBack _vehicle;
						_allsoldiers pushBack _unit;
						sleep 0.1;
					};

					if 	((_buildingType == "Land_Cargo_Patrol_V1_F") OR (_buildingType == "Land_Cargo_Patrol_V2_F") OR (_buildingType == "Land_Cargo_Patrol_V3_F")) exitWith {
						_vehicle = createVehicle [statMGtower, (_building buildingPos 1), [], 0, "CAN_COLLIDE"];
						_position = [getPosATL _vehicle, 2.5, (getDir _building) - 180] call BIS_Fnc_relPos;
						_vehicle setPosATL _position;
						_vehicle setDir (getDir _building) - 180;
						_vehicle setCenterOfMass [(getCenterOfMass _vehicle) vectorAdd [0, 0, -1], 0];
						_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
						_unit moveInGunner _vehicle;
						_allVehicles pushBack _vehicle;
						_allsoldiers pushBack _unit;
						sleep 0.1;
					};

					//Create planes in specified locations
					if ((_buildingType == "Land_JumpTarget_F") AND (!_isFrontline)) exitWith {
						_vehicle = createVehicle [selectRandom planes, position _building, [],0, "CAN_COLLIDE"];
						_vehicle setDir (getDir _building);
						_allVehicles pushBack _vehicle;
						sleep 0.1;
					};
					//Create heli in specified location
					if ((_buildingType == "Land_HelipadRescue_F") AND (!_isFrontline)) exitWith {
						_vehicle = createVehicle [selectRandom heli_armed, position _building, [],0, "CAN_COLLIDE"];
						_vehicle setDir (getDir _building);
						_allVehicles pushBack _vehicle;
						/*WiP: Engineers can consume their toolkit to unlock the vehicle.
						_vehicle lock 3;
						_vehicle addAction [localize "STR_ACT_TAKEFLAG", {if((_this select 1)(_this select 0) lock 0;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (_this getUnitTrait 'engineer')"]; */
						sleep 0.1;
					};

					if 	(_buildingType in listbld) exitWith {
						_vehicle = createVehicle [statMGtower, (_building buildingPos 13), [], 0, "CAN_COLLIDE"];
						_vehicle setCenterOfMass [(getCenterOfMass _vehicle) vectorAdd [0, 0, -1], 0];
						_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
						_unit moveInGunner _vehicle;
						_allSoldiers pushback _unit;
						sleep 0.1;
						_allVehicles pushback _vehicle;
						_vehicle = createVehicle [statMGtower, (_building buildingPos 17), [], 0, "CAN_COLLIDE"];
						_vehicle setCenterOfMass [(getCenterOfMass _vehicle) vectorAdd [0, 0, -1], 0];
						_unit = ([_markerPos, 0, infGunner, _groupGunners] call bis_fnc_spawnvehicle) select 0;
						_unit moveInGunner _vehicle;
						_allVehicles pushBack _vehicle;
						_allsoldiers pushBack _unit;
						sleep 0.1;
					};
				};
		};
	};

//Create bunker if it is frontline
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

//Create Mortars
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
		[_group, _patrolMarker, "SAFE","SPAWNED", "NOVEH2"] execVM "scripts\UPSMON.sqf";
		_allGroups pushBack _group;
		_currentCount = _currentCount +1;
	};

//Create transports
	/*if !(_busy) then {
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

			[_group, _marker, "SAFE","SPAWNED","NOFOLLOW","NOVEH"] execVM "scripts\UPSMON.sqf";
		};
		_allGroups pushBack _group;
	};*/

_flag = createVehicle [cFlag, _markerPos, [],0, "CAN_COLLIDE"];
_flag allowDamage false;
[_flag,"take"] remoteExec ["AS_fnc_addActionMP"];
_allVehicles pushBack _flag;

_crate = "I_supplyCrate_F" createVehicle _markerPos;
_allVehicles pushBack _crate;

//Create vehicles based on marker _size
	_arrayVeh = vehPatrol + vehSupply + enemyMotorpool - [heli_default];
	_vehicleCount = round (_size/45);
	_currentCount = 0;
	while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
		if (diag_fps > minimoFPS) then {
			_vehicleType = _arrayVeh call BIS_fnc_selectRandom;
			_position = [_markerPos, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			_vehicle = createVehicle [_vehicleType, _position, [], 0, "NONE"];
			_vehicle setDir random 360;
			_allVehicles pushBack _vehicle;
		};
		sleep 0.5;
		_currentCount = _currentCount + 1;
	};

	_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
	_group = [_markerPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
	//if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup}; no need to expand groups in airfield
	sleep 1;
	[_group, _marker, "SAFE", "RANDOMUP","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBack _group;

//Create soldiers based _vehiclecount
	_currentCount = 0;
	//if (_isFrontline) then {_vehicleCount = _vehicleCount * 2}; frontline in airport is draining too many possible slots, better add vehicles
	//_vehicleCount = round(0.3*_vehicleCount); //Lower the amount of infantry squads
	while {(spawner getVariable _marker) AND (_currentCount < _vehicleCount)} do {
		if (diag_fps > minimoFPS) then {
			while {true} do {
				_spawnPos = [_markerPos, 15 + (random _size),random 360] call BIS_fnc_relPos;
				if (!surfaceIsWater _spawnPos) exitWith {};
			};
			_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
			_group = [_spawnPos, side_green, _groupType] call BIS_Fnc_spawnGroup;
			//if (activeAFRF) then {_group = [_group, _markerPos] call AS_fnc_expandGroup}; no need to expand groups in airfield
			sleep 1;
			[_group, _marker, "SAFE","SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
			_allGroups pushBack _group;
		};
		sleep 1;
		_currentCount = _currentCount + 1;
	};
//Initialize vehicles
	{[_x] spawn genVEHinit} forEach _allVehicles;

	sleep 3;

//Deleting part of soldiers if the place was recently recaptured.
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

//Adding dog
	_group = createGroup civilian;
	_allGroups pushBack _group;
	_dog = _group createUnit ["Fin_random_F",_markerPos,[],0,"FORM"];
	[_dog] spawn guardDog;
	_allSoldiers pushBack _dog;

//Adding Press Reporter
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

diag_log format ["ANTISTASI_COUNTER: %1 spawned %2 and %3 vehicles",_marker,count _allsoldiers, count _allvehicles];

//Despawning conditions
	waitUntil {sleep 1;
		!(spawner getVariable _marker) OR

		(({!(vehicle _x isKindOf "Air")}
		 	count ([_size,0,_markerPos,"BLUFORSpawn"] call distanceUnits))
			> 3*
			count (allUnits select {(
				(side _x == side_green) OR
				(side _x == side_red)) AND
				(_x distance _markerPos <= (_size max 300)) AND
				!(captive _x) OR
				(lifeState _x == "INCAPACITATED")})
		)
	};

if ((spawner getVariable _marker) AND !(_marker in mrkFIA)) then {
	[_flag] remoteExec ["mrkWIN",2];
};

//Despawning
	waitUntil {sleep 1; !(spawner getVariable _marker)};

	deleteMarker _patrolMarker;
	[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
	if !(isNull _observer) then {deleteVehicle _observer};

//Save destroyed buildings
{
	if ((!alive _x) AND !(_x in destroyedBuildings)) then {
		destroyedBuildings = destroyedBuildings + [position _x];
		publicVariableServer "destroyedBuildings";
	};
} forEach _buildings;
