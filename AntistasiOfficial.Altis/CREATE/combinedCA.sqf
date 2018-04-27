if (!isServer and hasInterface) exitWith {};

params ["_marker",["_forceAirport",""]];
private ["_markerPos","_size","_allVehicles","_allGroups","_allSoldiers","_prestigeCSAT","_base","_airport","_involveCSAT","_threatEvaluationAir","_threatEvaluationLand","_originName","_targetName","_originMarker","_task","_attackDuration","_resourcesAAF","_originPosition","_maxCounter","_vehicleType","_timeOut","_spawnPosition","_vehicleData","_vehicle","_vehicleGroup","_redVehicles","_redGroups","_redSoldiers","_wp_01","_wp_02","_wp_03","_groupType","_group","_dismountPosition","_helipad","_posData","_initVehicle","_posRoad","_dir","_vehicleArray","_basesFIA","_initData","_groupCounter","_uav","_groupUAV","_seats","_groupTwo","_wpRTB"];

_allVehicles = [];
_allGroups = [];
_allSoldiers = [];

_redVehicles = [];
_redGroups = [];
_redSoldiers = [];

_markerPos = getMarkerPos (_marker);

_prestigeCSAT = server getVariable ["prestigeCSAT",0];

diag_log format ["Info: Attack triggered. Timer prior to attack: %1.", cuentaCA];

//Where attack start from
	_base = [_marker] call AS_fnc_findBaseForCA;
	_airport = [_marker] call AS_fnc_findAirportForCA;
	if ((_base == "") AND (_airport == "")) exitWith {diag_log format ["Info: Attack cancelled, no base available. Target location: %1.", _marker]};

//Involve CSAT or not
	_involveCSAT = false;
	if ((random 100 < _prestigeCSAT) AND (_prestigeCSAT > 44) AND !(server getVariable "blockCSAT")) then {_involveCSAT = true;};

if ((_airport != "") OR _involveCSAT) then {_threatEvaluationAir = [_marker] call AAthreatEval};
if (_base != "") then {_threatEvaluationLand = [_marker] call landThreatEval};

_targetName = [_marker] call AS_fnc_localizar;
_originMarker = [_base, _airport] select (_base == "");
_originName = ([_base, _airport] select (_base == "")) call AS_fnc_localizar;

_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE",A3_Str_INDEP,_originName],["%1 Attack",A3_Str_INDEP],_originMarker],getMarkerPos _originMarker,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;

misiones pushbackUnique "AtaqueAAF"; publicVariable "misiones";
_attackDuration = time + 2400;

//Adding caching area
	_spawnergroup = createGroup east;
	_spawner = _spawnergroup createUnit [selectrandom CIV_journalists, getmarkerpos _marker, [], 15,"None"];
	_spawner setVariable ["OPFORSpawn",true,true];
	_spawner disableAI "ALL";
	_spawner allowdamage false;
	_spawner setcaptive true;
	_spawner enableSimulation false;
	hideObjectGlobal _spawner;
sleep 15;

if !(_forceAirport == "") then {
	_involveCSAT = false;
	_base = "";
	_airport = _forceAirport;
};


if (_involveCSAT) then {
	_resourcesAAF = server getVariable ["resourcesAAF",0];
	if (_resourcesAAF > 20000) then {
		server setVariable ["resourcesAAF",_resourcesAAF - 20000,true];
		[5,0] remoteExec ["prestige",2];
	} else {
		[5,0] remoteExec ["prestige",2]
	};
	_originPosition = getMarkerPos "spawnCSAT";
	_originPosition set [2,300];
	_maxCounter = 3;
	if ((_base == "") OR (_airport == "")) then {_maxCounter = 3}; //Stef 21/01/2018 it was 6 before, no need to send that many CSAT, just increase too much AI spanwed

	//Creating CSAT airtransports
	for "_i" from 1 to _maxCounter do {
		if (_i == _maxCounter) then { _vehicleType = selectRandom opHeliTrans;} else {_vehicleType = selectRandom opAir;};
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
		_vehicle setVariable ["OPFORSpawn",true];
		_vehicleGroup = _vehicleData select 2;
		_redVehicles pushBack _vehicle;
		_redGroups pushBack _vehicleGroup;
		//Depending on vehicle type
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
				if ((_marker in bases) OR (_marker in aeropuertos) OR (random 10 < _threatEvaluationAir)) then {
					{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _group;
					[_vehicle,_group,_marker,_threatEvaluationAir] spawn airdrop;
				} else {
					if ((random 100 < 50) OR (_vehicleType == opHeliDismount)) then {
						{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _vehicleGroup;
						_dismountPosition = [];
						_dismountPosition = [_markerPos, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
						_dismountPosition set [2, 0];
						_helipad = createVehicle ["Land_HelipadEmpty_F", _dismountPosition, [], 0, "NONE"];
						_allVehicles pushBack _helipad;
						[_vehicleGroup, _originPosition, _dismountPosition, _marker, _group, 60*60, "air"] spawn AS_fnc_QRF_dismountTroops;
					} else {[_vehicleGroup, _originPosition, _markerPos, _marker, _group, 60*60] spawn AS_fnc_QRF_fastrope;};
				};
			};
	sleep 15;
	};

	_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE_RED",A3_Str_INDEP,A3_Str_RED,_targetName,_originName],["%1/%2 Attack",A3_Str_INDEP,A3_Str_RED],_marker],getMarkerPos _marker,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
	[_targetNam,{["TaskSucceeded", ["", format [localize "STR_TSK_TD_CA_TARGET",_this]]] call BIS_fnc_showNotification}] remoteExec ["call", 0];

	[_marker] spawn {
		params ["_targetMarker"];
		for "_i" from 0 to round (random 2) do {
			[_targetMarker, selectRandom opCASFW] spawn airstrike;
			sleep 30;
		};
		if ((_targetMarker in bases) OR (_targetMarker in aeropuertos)) then {
			[_targetMarker] spawn artilleria;
		};
	};
	sleep 2;
	{if ((surfaceIsWater position _x) and (vehicle _x == _x)) then {_x setDamage 1}} forEach _allSoldiers; //Soldiers in water won't be effective anyway.

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
// AAF sending attack from base
if !(_base == "") then {
	[_base,10] spawn AS_fnc_addTimeForIdle;	//Stef 21/01/2018 no need to have the base in idle for 1 hour, it will just decrease the enemy activity that would be restored after a restart anyway.
	_originPosition = getMarkerPos _base;
	_size = [_base] call sizeMarker;
	_maxCounter = 1 max (round (_size/30));

	for "_i" from 1 to _maxCounter do {
		if (count (enemyMotorpool - vehPatrol) > 0) then {
			_vehicleType = enemyMotorpoolDef;
			_vehicleArray =+ (enemyMotorpool - vehPatrol);
			if (_i == _maxCounter) then {
				_basesFIA = count (mrkFIA arrayIntersect (bases + aeropuertos));
				call {
					if (_basesFIA < 1) exitWith {
						_vehicleArray = _vehicleArray - vehTank - vehIFV;
					};
					if (_basesFIA < 3) exitWith {
						_vehicleArray = _vehicleArray - vehTank;
					};
					_vehicleArray = vehTank;
				};
			} else {
				call {
					if ((_threatEvaluationLand > 5) AND (count (enemyMotorpool arrayIntersect (vehTank + vehIFV)) > 0)) then {
						_vehicleArray = _vehicleArray - vehPatrol - vehTrucks;
					};
					if ((_threatEvaluationLand > 3) AND (count (enemyMotorpool arrayIntersect (vehIFV + vehAPC)) > 0)) then {
						_vehicleArray = _vehicleArray - vehTrucks;
					};
				};
			};

			_vehicleType = _vehicleArray call BIS_fnc_selectRandom;
		};

		//Depending on vehicle type
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
			_posData = [_originPosition, _markerPos] call AS_fnc_findSpawnSpots;
			_posRoad = _posData select 0;
			_dir = _posData select 1;
			_initData = [_posRoad, _dir, _vehicleType, side_green] call bis_fnc_spawnvehicle;
			_allVehicles = _allVehicles + (_initData select [0,1]); //Stef the problem is it add a "string" instead of a ["string"] so i added brackets
			_allGroups = _allGroups + (_initData select [2,1]); // Stef: it was 1 and was selecting all units instead of the group according to  bis_fnc_spawnvehicle biki so changed and added brackets
			_wp_01 = (_initData select 2) addWaypoint [_markerPos, 0]; //Stef waypoint was selecting the wrong reference.
			_wp_01 setWaypointBehaviour "SAFE";
			[(_initData select 0),"Tank"] spawn inmuneConvoy;
			(_initData select 0) allowCrewInImmobile true;
			_wp_01 setWaypointType "SAD";
		};
	sleep 5;
	};
};

//AAF sending unit from airport
if !(_airport == "") then {
	[_airport,10] spawn AS_fnc_addTimeForIdle;
	if (_base != "") then {sleep ((_originPosition distance _markerPos)/16)};
	_originPosition = getMarkerPos _airport;
	_originPosition set [2,300];
	_uav = createVehicle [indUAV_large, _originPosition, [], 0, "FLY"];
	_allVehicles pushBack _uav;
	[_uav,"UAV"] spawn inmuneConvoy;
	[_uav,_marker] spawn VANTinfo;
	createVehicleCrew _uav;
	_groupUAV = group (crew _uav select 0);
	_allGroups pushBack _groupUAV;
	[_groupUAV, _originPosition, _markerPos, 600, 60] spawn AS_fnc_QRF_loiter;
	_uav removeMagazines "6Rnd_LG_scalpel";
	sleep 5;

	for "_i" from 1 to 3 do {
		if (_i == 3) then {
			_vehicleType = heli_unarmed call BIS_fnc_selectRandom;
		} else {
			_vehicleArray =+ indAirForce arrayIntersect (heli_armed + heli_unarmed);
			call {
				if ((count (_vehicleArray arrayIntersect heli_armed) > 0)) then {_vehicleArray = heli_armed;};
				if !(count _vehicleArray > 0) then {_vehicleArray = heli_unarmed;};
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
		_vehicle setVariable ["OPFORSpawn",true];
		_vehicleGroup = _vehicleData select 2;
		_allGroups pushBack _vehicleGroup;
		_allVehicles pushBack _vehicle;

		if !(_vehicleType in heli_unarmed) then {
			[_vehicleGroup, _originPosition, _markerPos, 400, 2400] spawn AS_fnc_QRF_loiter;
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

				[_vehicleGroup, _originPosition, _dismountPosition, _marker, _group, 2400, "air"] spawn AS_fnc_QRF_dismountTroops;
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
				[_vehicleGroup, _spawnPosition, _dismountPosition, _marker, [_group, _groupTwo], 2400] spawn AS_fnc_QRF_fastrope;
			};
		};

		if !(_i == 3) then {
			sleep 15;
		};
	};
};

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

diag_log format ["groups: %1; vehicles: %2; soldiers: %3", _allGroups, _allVehicles, _allSoldiers];

//forcedSpawn pushBack _marker; //Sparker: force spawn a base under attack
//publicVariable "forcedSpawn";

//Retreat conditions
waitUntil
{
	sleep 5;
	(
	 	//Operative soldiers < 1/3 of All soldiers
		( {((alive _x) and (lifeState _x != "INCAPACITATED"))} count _allSoldiers < (round ((count _allSoldiers)/3)) ) OR

		//time is over
		(time > _attackDuration) OR

		//objective has been captured
		(_marker in mrkAAF) OR

		//(Operative FIA within 100m) < (Operative AAF within 100m)
		(2*count (allUnits select {(side _x == side_blue) AND (_x distance _markerPos <= 100) and (lifeState _x != "INCAPACITATED")})
		) < count (
			allUnits select {
				((side _x == side_green) OR (side _x == side_red)) AND
				(_x distance _markerPos <= 100) and
				(lifeState _x != "INCAPACITATED")
			}
		)
	)
};

diag_log format ["Info: Attack on %1 %2.", _marker, ["failed","succeeded"] select (_marker in mrkAAF)];

if !(_marker in mrkAAF) then {
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_markerPos,"BLUFORSpawn"] call distanceUnits);
	[5,Slowhand] call playerScoreAdd;
	if !(_involveCSAT) then {
		_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE",A3_Str_INDEP,_originName],["%1 Attack",A3_Str_INDEP],_originMarker],getMarkerPos _originMarker,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
	} else {
		_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE_RED",A3_Str_INDEP,A3_Str_RED,_targetName,_originName],["%1/%2 Attack",A3_Str_INDEP,A3_Str_RED],_marker],getMarkerPos _marker,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
	};
	{_x doMove _originPosition} forEach _allSoldiers;
	{_wpRTB = _x addWaypoint [_originPosition, 0]; _x setCurrentWaypoint _wpRTB} forEach _allGroups;
} else {
	[-10,Slowhand] call playerScoreAdd;
	if (!_involveCSAT) then {
		_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE",A3_Str_INDEP,_originName],["%1 Attack",A3_Str_INDEP],_originMarker],getMarkerPos _originMarker,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
	} else {
		_task = ["AtaqueAAF",[side_blue,civilian],[["STR_TSK_TD_CA_CREATE_RED",A3_Str_INDEP,A3_Str_RED,_targetName,_originName],["%1/%2 Attack",A3_Str_INDEP,A3_Str_RED],_marker],getMarkerPos _marker,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
	};
};

[2700] remoteExec ["AS_fnc_increaseAttackTimer",2];
if (cuentaCA < 0) then {
	cuentaCA = 600;
};

sleep 30;
[0,_task] spawn borrarTask;
waitUntil {sleep 1; !(spawner getVariable _marker)};

[_allGroups + _redGroups, _allSoldiers + _redSoldiers, _allVehicles + _redVehicles] spawn AS_fnc_despawnUnits;

deleteVehicle _spawner;
deleteGroup _spawnergroup;

