if (!isServer and hasInterface) exitWith {};

if (server getVariable "blockCSAT") exitWith {diag_log format ["Info: Small attack on %1 called off, communications blocked.", _marker]};

params ["_marker",["_forceBase",""]];
private ["_markerPos","_allVehicles","_allGroups","_allSoldiers","_base","_airport","_forcedAttack","_exit","_nearestMarker","_radioContact","_involveCSAT","_threatEvaluation","_attackDuration","_originPosition","_maxCounter","_vehicleType","_timeOut","_spawnPosition","_vehicleData","_vehicle","_vehicleGroup","_redVehicles","_redGroups","_redSoldiers","_wp_01","_wp_02","_wp_03","_groupType","_group","_dismountPosition","_helipad","_posData","_initVehicle","_posRoad","_dir","_vehicleArray","_initData","_groupCounter","_seats","_groupTwo"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_redVehicles = [];
_redGroups = [];
_redSoldiers = [];

_isMarker = !(typeName _marker == "ARRAY");
_markerPos = _marker;
if (typeName _marker == "STRING") then {_markerPos = getMarkerPos (_marker)};
_forcedAttack = false;

_base = "";
_airport = "";
if !(_forceBase == "") then {
	_base = ["", _forceBase] select (_forceBase in bases);
	_airport = ["", _forceBase] select (_forceBase in aeropuertos);
	_forcedAttack = true;
};

//Conditions to prevent the counterattack
	//diag_fps
		if (!(_forcedAttack) AND (count allunits > 200)) exitWith {diag_log format ["Info: Small attack on %1 called off, too many units.", _marker]};

		_exit = false;
	//another counterattack active in same zone (disabled)
		if (_isMarker) then {
			if (!_forcedAttack) then {
				if (_marker in smallCAmrk) then {
					_exit = true;
				};
			};
		} else {
			_nearestMarker = [smallCApos,_marker] call BIS_fnc_nearestPosition;
			if (_nearestMarker distance _marker < (distanciaSPWN/2)) then {
				_exit = true;
			} else {
				if (count smallCAmrk > 0) then {
					_nearestMarker = [smallCAmrk,_marker] call BIS_fnc_nearestPosition;
					if (getMarkerPos _nearestMarker distance _marker < (distanciaSPWN/2)) then {_exit = true};
				};
			};
		};
	//if (_exit) exitWith {diag_log format ["Info: Small attack on %1 called off, nearby small attack already in progress.", _marker]}; //Stef 05/12 patrolca should replace dead units, so no points to prevent several in same zone.
	//missing radio coverage (disabled)
		//_radioContact = [([_marker] call AS_fnc_radioCheck), true] select (_forcedAttack);  Stef 21/09 removed Radiotower QRF check.
		//if !(_radioContact) exitWith {diag_log format ["Info: Small attack on %1 called off, no radio contact.", _marker]};

if !(_forcedAttack) then {
	_base = [_marker] call AS_fnc_findBaseForCA;
	if (_base == "") then {_airport = [_marker] call AS_fnc_findAirportForCA};
};

_involveCSAT = false;
if ((_base == "") AND (_airport == "")) then {
	_involveCSAT = (random 100 < server getVariable "prestigeCSAT");
};

if ((_base == "") AND (_airport == "") AND !(_involveCSAT)) exitWith {diag_log format ["Info: Small attack on %1 called off, no base to attack from.", _marker]};

// threatEval -- it isn't working because of unlocks missing; values should be adjusted to different conditions
	if ((_base == "") AND (!(_airport == "") OR (_involveCSAT))) then {
		_threatEvaluation = [_markerPos] call AAthreatEval;
		if (!(_airport == "") AND !(_forcedAttack)) then {
			if ((_threatEvaluation > 15) AND !(count (indAirForce arrayIntersect planes) > 0)) then {
				_airport = "";
			} else {
				if ((_threatEvaluation > 10) AND !(count (indAirForce arrayIntersect (heli_armed + planes)) > 0)) then {
					_airport = "";
				};
			};
		};
	};

	if !(_base == "") then {
		_threatEvaluation = [_markerPos] call landThreatEval;
		if !(_forcedAttack) then {
			if ((_threatEvaluation > 15) AND !(count (enemyMotorpool arrayIntersect vehTank) > 0)) then {
				_base = "";
			} else {
				if ((_threatEvaluation > 5) AND (count (enemyMotorpool arrayIntersect (vehAPC + vehIFV + vehTank)) > 0)) then {
					_base = "";
				};
			};
		};
	};

if ((_base == "") AND (_airport == "") AND !(_involveCSAT)) exitWith {diag_log format ["Info: Small attack on %1 called off, threat level too high (%2).", _marker, _threatEvaluation]};

if (_isMarker) then {
	smallCAmrk pushBackUnique _marker;
	publicVariable "smallCAmrk";
	_attackDuration = time + 3600;
} else {
	smallCApos pushBack _marker;
	publicVariable "smallCApos";
};

diag_log format ["Info: Small attack on %1 triggered, starting from %2 with %3 involvement.", _marker, [_airport, _base] select (_airport == ""), ["no CSAT", "CSAT"] select (_involveCSAT)];

_allSoldiers = [];
_allVehicles = [];
_allGroups = [];
_roads = [];

//Smallcounterattack sent from base
	//Find spawn position
	if !(_base == "") then {
		_airport = "";
		_involveCSAT = false;
		if !(_forcedAttack) then {[_base,2] spawn AS_fnc_addTimeForIdle};
		_originPosition = getMarkerPos _base;
		_posData = [_originPosition, _markerPos] call AS_fnc_findSpawnSpots;
		_posRoad = _posData select 0;
		_dir = _posData select 1;

		_vehicleType = enemyMotorpoolDef;
		//threat eval isn't working and tanks are bad as qrf because of their poor behaviour
		if (count (enemyMotorpool - vehPatrol) > 1) then {
			_vehicleArray =+ (enemyMotorpool - vehPatrol -vehTank);
			call {
				if ((_threatEvaluation > 5) AND (count (enemyMotorpool arrayIntersect (vehTank + vehIFV)) > 0)) exitWith {
					_vehicleArray = _vehicleArray - vehTrucks - vehTank;
				};
				if ((_threatEvaluation > 3) AND (count (enemyMotorpool arrayIntersect (vehIFV + vehAPC)) > 0)) then {
					_vehicleArray = _vehicleArray - vehTrucks - vehTank;
				};
			};

			_vehicleType = _vehicleArray call BIS_fnc_selectRandom;
		};

		if !(_vehicleType in vehTank) then {
			call {
				if (_vehicleType in vehIFV) then {
					_groupType = [infTeam, side_green] call AS_fnc_pickGroup;
					_groupCounter = 1;
				};
				if (_vehicleType in vehAPC) then {
					_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
					_groupCounter = 1;
				};
				if (_vehicleType in vehTrucks) then {
					_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
					_groupCounter = 2;
				};
			};
			_initData = [_vehicleType,_groupType,_groupCounter,_originPosition,_marker] call AS_fnc_groundTransport;
			_allVehicles = _allVehicles + (_initData select 0);
			_allGroups = _allGroups + (_initData select 1);
		} else {
			_initData = [_posRoad, _dir, _vehicleType, side_green] call bis_fnc_spawnvehicle;
			_allVehicles = _allVehicles + (_initData select [0,1]);
			_allGroups = _allGroups + (_initData select [2,1]);

			_wp_01 = (_initData select 2) addWaypoint [_markerPos, 0];
			_wp_01 setWaypointBehaviour "SAFE";
			[(_initData select 0),"Tank"] spawn inmuneConvoy;
			(_initData select 0) allowCrewInImmobile true;
			_wp_01 setWaypointType "SAD";
		};
	};

//SmallCounterattack sent from Airport
	if !(_airport == "") then {
		if !(_forcedAttack) then {[_airport,2] spawn AS_fnc_addTimeForIdle};
		_originPosition = getMarkerPos _airport;
		_vehicleArray = (indAirForce - planes);
		_maxCounter = [1,2] select (_isMarker);
		for "_i" from 1 to _maxCounter do {
			_vehicleType = selectRandom heli_unarmed;
			if (_i < _maxCounter) then {
				_vehicleArray =+ indAirForce arrayIntersect (heli_armed + heli_unarmed);
				call {
					if ((_threatEvaluation > 7) AND (count (_vehicleArray arrayIntersect heli_armed) > 0)) then {
						_vehicleArray = heli_armed;
					};
					if ((_threatEvaluation > 14) AND (count (_vehicleArray arrayIntersect planes) > 0)) then {
						_vehicleArray = planes;
					};

					if !(count _vehicleArray > 0) then {
						_vehicleArray = heli_unarmed;
					};
				};

				_vehicleType = _vehicleArray call BIS_fnc_selectRandom;
			};

			_timeOut = 0;
			_spawnPosition = _originPosition findEmptyPosition [0,100,heli_transport];
			while {_timeOut < 60} do {
				if (count _spawnPosition > 0) exitWith {};
				_timeOut = _timeOut + 1;
				_spawnPosition = _originPosition findEmptyPosition [0,100,heli_transport];
				sleep 1;
			};
			if (_spawnPosition isEqualTo []) then {_spawnPosition = _originPosition};

			_vehicleData = [_spawnPosition, [_spawnPosition, _markerPos] call BIS_fnc_dirTo,_vehicleType, side_green] call bis_fnc_spawnvehicle;
			_vehicle = _vehicleData select 0;
			_vehicleGroup = _vehicleData select 2;
			_allGroups pushBack _vehicleGroup;
			_allVehicles pushBack _vehicle;

			if !(_vehicleType in heli_unarmed) then {
				[_vehicleGroup, _originPosition, _markerPos, 400, 60] spawn AS_fnc_QRF_loiter;
				[_vehicle,"Air Attack"] spawn inmuneConvoy;
			} else {
				_seats = ([_vehicleType,true] call BIS_fnc_crewCount) - ([_vehicleType,false] call BIS_fnc_crewCount);
				if (_seats <= 12) then {
					if (_seats <= 7) then {
						_groupType = [infTeam, side_green] call AS_fnc_pickGroup;
					} else {
						_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
					};
					_group = [_originPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
					{_x assignAsCargo _vehicle;_x moveInCargo _vehicle} forEach units _group;
					_allGroups pushBack _group;

					_dismountPosition = [_markerPos, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
					_dismountPosition set [2, 0];
					_helipad = createVehicle ["Land_HelipadEmpty_F", _dismountPosition, [], 0, "NONE"];
					_allVehicles = _allVehicles + [_helipad];

					[_vehicleGroup, _originPosition, _dismountPosition, _marker, _group, 60*60, "air"] spawn AS_fnc_QRF_dismountTroops;
					[_vehicle,"Air Transport"] spawn inmuneConvoy;
				} else {
					_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
					_group = [_originPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
					{_x assignAsCargo _vehicle;_x moveInCargo _vehicle} forEach units _group;
					_allGroups pushBack _group;
					_groupTwo = [_originPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
					{_x assignAsCargo _vehicle;_x moveInCargo _vehicle} forEach units _groupTwo;
					_allGroups pushBack _groupTwo;
					_dismountPosition = [_markerPos, 150, 300, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
					[_vehicleGroup, _spawnPosition, _dismountPosition, _marker, [_group, _groupTwo], 60*60] spawn AS_fnc_QRF_fastrope;
				};
			};

			if !(_i == _maxCounter) then {
				sleep 15;
			};
		};
	};

//Initialise AAF units and vehicles created
	{
		_group = _x;
		_group allowFleeing 0;
		{
			[_x] spawn genInit;
			_allSoldiers pushBack _x;
		} forEach units _group;
	} forEach _allGroups;

	{
		[_x] spawn genVEHinit;
	} forEach _allVehicles;

//Smallcounterattack reinforced by CSAT
	if (_involveCSAT) then {
		_originPosition = getMarkerPos "spawnCSAT";
		_originPosition set [2,300];
		for "_i" from 1 to 3 do {
			_vehicleType = selectRandom opHeliTrans;
			if (_i < 3) then {
				_vehicleType = selectRandom ([opAir, (opAir - opHeliTrans)] select (_threatEvaluation > 10));
			};

			_timeOut = 0;
			_spawnPosition = _originPosition findEmptyPosition [0,100,_vehicleType];
			while {_timeOut < 60} do {
				if (count _spawnPosition > 0) exitWith {};
				_timeOut = _timeOut + 1;
				_spawnPosition = _originPosition findEmptyPosition [0,100,_vehicleType];
				sleep 1;
			};
			if (_spawnPosition isEqualTo []) then {_spawnPosition = _originPosition};

			_vehicleData = [_originPosition, 0, _vehicleType, side_red] call bis_fnc_spawnvehicle;
			_vehicle = _vehicleData select 0;
			_vehicleGroup = _vehicleData select 2;
			_redVehicles pushBack _vehicle;
			_redGroups pushBack _vehicleGroup;

			if !(_vehicleType in opHeliTrans) then{
				_wp_01 = _vehicleGroup addWaypoint [_markerPos, 0];
				_wp_01 setWaypointType "SAD";
				[_vehicle,"CSAT Air Attack"] spawn inmuneConvoy;
			} else {
				{_x setBehaviour "CARELESS";} forEach units _vehicleGroup;
				_groupType = [opGroup_Squad, side_red] call AS_fnc_pickGroup;
				_group = [_originPosition, side_red, _groupType] call BIS_Fnc_spawnGroup;
				{_x assignAsCargo _vehicle; _x moveInCargo _vehicle} forEach units _group;
				_redGroups pushBack _group;
				[_vehicle,"CSAT Air Transport"] spawn inmuneConvoy;
				if ((_marker in bases) OR (_marker in aeropuertos) OR (random 10 < _threatEvaluation)) then {
					{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _group;
					[_vehicle,_group,_marker,_threatEvaluation] spawn airdrop;
				}
				else {
					if ((random 100 < 50) OR (_vehicleType == opHeliDismount)) then {
						{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _vehicleGroup;
						_dismountPosition = [];
						_dismountPosition = [_markerPos, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
						_dismountPosition set [2, 0];
						_helipad = createVehicle ["Land_HelipadEmpty_F", _dismountPosition, [], 0, "NONE"];
						_allVehicles pushBack _helipad;

						[_vehicleGroup, _originPosition, _dismountPosition, _marker, _group, 60*60, "air"] spawn AS_fnc_QRF_dismountTroops;
					} else {
						[_vehicleGroup, _originPosition, _markerPos, _marker, _group, 60*60] spawn AS_fnc_QRF_fastrope;
					};
				};
			};
			sleep 15;
		};
		{
			_group = _x;
			{
				[_x] spawn CSATinit; _redSoldiers pushBack _x;
			} forEach units _group;
		} forEach _redGroups;

		{
			[_x] spawn CSATVEHinit;
		} forEach _redVehicles;
	};

//Retreat conditions
	if (_isMarker) then {
		waitUntil {sleep 5;(

			//
			({(alive _x) and (lifeState _x != "INCAPACITATED")} count _allSoldiers < (round ((count _allSoldiers)/3))) OR

			//
			(_marker in mrkAAF) OR

			//
			(time > _attackDuration)
		)
	};

		smallCAmrk = smallCAmrk - [_marker];
		publicVariable "smallCAmrk";

		waitUntil {sleep 1; not (spawner getVariable _marker)};
	} else {
		waitUntil {sleep 1; !([distanciaSPWN,1,_markerPos,"BLUFORSpawn"] call distanceUnits)};
		smallCApos = smallCApos - [_marker];
		publicVariable "smallCApos";
	};

	[_allGroups + _redGroups, _allSoldiers + _redSoldiers, _allVehicles + _redVehicles] spawn AS_fnc_despawnUnits;
