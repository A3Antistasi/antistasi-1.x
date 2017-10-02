if (!isServer and hasInterface) exitWith {};

/*
parameters
0: destination of the convoy (marker)
1: origin of the convoy (marker)
2: source of the mission request ("civ", "mil", "auto", "city") -- OPTIONAL
3: specified types of convoys (array) -- OPTIONAL
*/
params ["_destination", "_base", ["_source", "auto"], "_convoyTypes"];
private ["_posbase","_posDestination","_units","_groups","_vehicles","_POWs","_timeLimit","_endTime","_endTimeNumber","_posData","_posRoad","_dir","_escortType","_objectiveType","_groupType","_convoyTypeArray","_posHQ","_val","_weights","_delay","_startTime","_startTimeNumber","_destinationName","_originName","_tskTitle","_tskDesc","_icon","_group","_vehData","_counter","_HVTveh","_vehObj","_vehObj2","_hvt","_tempMP","_motorpool","_wp0","_FIAbases","_AAFtanks","_veh","_tempGroup","_driver","_groupPOW","_unit","_params","_tskOutcome","_convoyType"];

_posbase = getMarkerPos _base;
_posDestination = getMarkerPos _destination;

_units = [];
_groups = [];
_vehicles = [];

_posData = [];
_posRoad = [];
_dir = 0;

_escortType = "";
_objectiveType = "";
_groupType = "";
_convoyTypeArray = [];
_posHQ = getMarkerPos guer_respawn;

_timeLimit = 120;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _timeLimit];
_endTimeNumber = dateToNumber _endTime;

call {
	if (count _this > 3) exitWith {_convoyTypeArray = _convoyTypes};

	if (_source == "civ") exitWith {
		_convoyTypeArray = [["Money","Supplies"], ["Prisoners","HVT"]] select (_destination in bases);
		_val = server getVariable "civActive";
		server setVariable ["civActive", _val + 1, true];
	};

	if (_source == "mil") exitWith {
		_convoyTypeArray = ["Municion","Armor","HVT"];
		_val = server getVariable "milActive";
		server setVariable ["milActive", _val + 1, true];
	};

	if (_source == "auto") exitWith {
		_convoyTypeArray = ["HVT"];
	};

	if (_source == "city") exitWith {
		_convoyTypeArray = ["Supplies", "Money"];
		_weights = [0.8, 0.1];
		_convoyType = [_convoyTypeArray, _weights] call BIS_fnc_selectRandomWeighted;
	};
};

if (isNil "_weights") then {
	_convoyType = _convoyTypeArray call BIS_Fnc_selectRandom;
} else {
	_convoyType = [_convoyTypeArray, _weights] call BIS_fnc_selectRandomWeighted;
};

// add a delay, depending on the number of places you control
_delay = (round (5 - (count mrkFIA)/10)) + (round random 10);
_startTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _delay];
_startTimeNumber = dateToNumber _startTime;

_destinationName = [_destination] call AS_fnc_localizar;
_originName = [_base] call AS_fnc_localizar;
[_base,30] spawn AS_fnc_addTimeForIdle;

call {
	if (_convoyType == "Municion") exitWith {
		_tskTitle = localize "STR_TSK_CVY_AMMO";
		_tskDesc = localize "STR_TSKDESC_CVY_AMMO";
		_icon = "rearm";
		_objectiveType = vehAmmo;
	};

	if (_convoyType == "Armor") exitWith {
		_tskTitle = localize "STR_TSK_CVY_ARMOR";
		_tskDesc = localize "STR_TSKDESC_CVY_ARMOR";
		_icon = "Destroy";
		_objectiveType = [selectRandom vehIFV, selectRandom vehTank] select ({(_x in vehTank)} count enemyMotorpool > 0);
	};

	if (_convoyType == "Prisoners") exitWith {
		_tskTitle = localize "STR_TSK_CVY_PRIS";
		_tskDesc = localize "STR_TSKDESC_CVY_PRIS";
		_icon = "run";
		_objectiveType = enemyMotorpoolDef;
	};

	if (_convoyType == "Money") exitWith {
		_tskTitle = localize "STR_TSK_CVY_MONEY";
		_tskDesc = localize "STR_TSKDESC_CVY_MONEY";
		_icon = "move";
		_objectiveType = AS_misVehicleBox;
		};

	if (_convoyType == "Supplies") exitWith {
		_tskTitle = localize "STR_TSK_CVY_SUPPLY";
		_tskDesc = localize "STR_TSKDESC_CVY_SUPPLY";
		_icon = "heal";
		_objectiveType = AS_misVehicleBox;
		};

	if (_convoyType == "HVT") exitWith {
		_tskTitle = localize "STR_TSK_CVY_HVT";
		_tskDesc = localize "STR_TSKDESC_CVY_HVT";
		_icon = "Destroy";
		_objectiveType = selectRandom standardMRAP;
	};
};

_tsk = ["CONVOY",[side_blue,civilian],[format [_tskDesc,_originName,numberToDate [2035,_startTimeNumber] select 3,numberToDate [2035,_startTimeNumber] select 4,_destinationName],format [_tskTitle, A3_Str_INDEP],_destination],_posDestination,"CREATED",5,true,true,_icon] call BIS_fnc_setTask;

misiones pushBack _tsk; publicVariable "misiones";

_posData = [_posbase, _posDestination] call AS_fnc_findSpawnSpots;
_posRoad = _posData select 0;
_dir = _posData select 1;

// initialisation of vehicles
_initVehs = {
	params ["_specs"];
	_specs = _specs + [_dir, side_green, _vehicles, _groups, _units, true];
	_specs call AS_fnc_initialiseVehicle;
};

_addWaypoint = {
	params ["_wpData"];
	_wp0 = (_wpData select 1) addWaypoint [_posDestination, count waypoints (_wpData select 1)];
	_wp0 = (waypoints (_wpData select 1)) select 0;
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointBehaviour "SAFE";
	(_wpData select 1) setBehaviour "SAFE";
	_wp0 setWaypointFormation "COLUMN";
	(_wpData select 0) limitSpeed 50;
};

sleep (_delay * 60);

_vehData = [[_posRoad, selectRandom vehLead]] call _initVehs;
_vehicles = _vehData select 0;
_groups = _vehData select 1;
_units = _vehData select 2;

[_vehData select 3] call _addWaypoint;

_counter = [1, (round random 2) + 1] select ([_destination] call AS_fnc_isFrontline);
_HVTveh = 0;
_tempMP = [];
if (activeAFRF) then {
	if (count (enemyMotorpool arrayIntersect vehIFV) > 0) then {
		for "_j" from 1 to 4 do {
			_tempMP pushBack selectRandom vehIFV;
		};
	};
};

_motorpool =+ enemyMotorpool;
if (count _tempMP > 0) then {_motorpool = _motorpool - vehIFV + _tempMP};

if (_convoyType == "HVT") then {
	sleep 15;
	_HVTveh = round random 1;

	_vehData = [[_posRoad, _objectiveType]] call _initVehs;
	_vehicles = _vehData select 0;
	_groups = _vehData select 1;
	_units = _vehData select 2;

	_vehObj2 = (_vehData select 3) select 0;
	[_vehObj2,"AAF Convoy Objective"] spawn inmuneConvoy;

	if (_HVTveh == 0) then {
		_hvt = ([_posbase, 0, sol_OFF, (_vehData select 3) select 1] call bis_fnc_spawnvehicle) select 0;
		[_hvt] spawn genInit;
		_hvt assignAsCargo _vehObj2;
		_hvt moveInCargo _vehObj2;
		_units pushBack _hvt;
		_vehObj2 lock 2;
		[_vehObj2, true] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
	};

	[_vehData select 3] call _addWaypoint;
} else {
	for "_i" from 1 to _counter do {
		sleep 15;
		if (count _motorpool > 1) then {
			_motorpool = _motorpool - [enemyMotorpoolDef];
			_escortType = _motorpool call BIS_fnc_selectRandom;
		} else {
			_escortType = enemyMotorpoolDef;
		};

		_FIAbases = mrkFIA arrayIntersect (bases + aeropuertos);
		_AAFtanks = _motorpool arrayIntersect vehTank;
		if ((count _FIAbases > 2) && (count _AAFtanks > 0) && (_i == _counter)) then {_escortType = selectRandom vehTank};

		_vehData = [[_posRoad, _escortType]] call _initVehs;
		_vehicles = _vehData select 0;
		_groups = _vehData select 1;
		_units = _vehData select 2;

		_veh = (_vehData select 3) select 0;
		[_veh,"AAF Convoy Escort"] spawn inmuneConvoy;

		if !(_escortType in vehTank) then {
			_groupType = [infSquad, infTeam] select (_escortType in vehIFV);
			_groupType = [_groupType, side_green] call AS_fnc_pickGroup;

			_tempGroup = [_posbase, side_green, _groupType] call BIS_Fnc_spawnGroup;
			{[_x] spawn genInit;_x assignAsCargo _veh;_x moveInCargo _veh; _units pushBack _x; [_x] join ((_vehData select 3) select 0)} forEach units _tempGroup;
			deleteGroup _tempGroup;
			if (_escortType != enemyMotorpoolDef) then {
				[_veh] spawn smokeCover;
			};
		};

		[_vehData select 3] call _addWaypoint;
	};
};

sleep 20;

_vehObj = _objectiveType createVehicle _posRoad;
_vehObj allowDamage false;
_vehObj setDir _dir;
_vehObj addEventHandler ["HandleDamage", {
	if (((_this select 1) find "wheel" != -1) && !([distanciaSPWN,1,_vehObj,"BLUFORSpawn"] call distanceUnits)) then {
		0;
	} else {
		(_this select 2);
	};
}];

_group = createGroup side_green;
_driver = ([_posbase, 0, sol_DRV, _group] call bis_fnc_spawnvehicle) select 0;
_driver assignAsDriver _vehObj;
_driver moveInDriver _vehObj;
[_driver] spawn genInit;
_units pushBackUnique _driver;
_driver addEventHandler ["killed", {
	{
		_x action ["EJECT", _vehObj];
		unassignVehicle _x;
	} forEach crew _vehObj;
}];

{
	_x removeWeaponGlobal (primaryWeapon _x);
} forEach crew _vehObj;

if ((_convoyType == "HVT") && (_HVTveh == 1)) then {
	_hvt = ([_posbase, 0, sol_OFF, _group] call bis_fnc_spawnvehicle) select 0;
	[_hvt] spawn genInit;
	_hvt assignAsCargo _vehObj;
	_hvt moveInCargo _vehObj;
	_units pushBack _hvt;
	_vehObj lock 2;
	[_vehObj, true] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
};

_vehicles pushBack _vehObj;
_groups pushBack _group;
[[_vehObj, _group]] call _addWaypoint;

call {
	if (_convoyType == "Armor") exitWith {_vehObj lock 3};

	if (_convoyType == "Prisoners") exitWith {
		_POWs = [];
		_groupPOW = createGroup side_blue;
		_groups pushBack _groupPOW;
		for "_i" from 1 to (1+ round (random 11)) do {
			_unit = _groupPOW createUnit [guer_POW, _posbase, [], 0, "NONE"];
			_unit setCaptive true;
			_unit disableAI "MOVE";
			_unit setBehaviour "CARELESS";
			_unit allowFleeing 0;
			_unit assignAsCargo _vehObj;
			_unit moveInCargo [_vehObj, _i + 3];
			removeAllWeapons _unit;
			removeAllAssignedItems _unit;
			[[_unit,"refugiado"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			sleep 1;
			_POWs pushBack _unit;
		};
	};

	if ((_convoyType == "Money") or (_convoyType == "Supplies")) exitWith {reportedVehs pushBack _vehObj; publicVariable "reportedVehs"};
};

sleep 20;

if (count _motorpool > 1) then {
	_motorpool = _motorpool - [enemyMotorpoolDef];
	_escortType = _motorpool call BIS_fnc_selectRandom;
} else {
	_escortType = enemyMotorpoolDef;
};

_vehData = [[_posRoad, _escortType]] call _initVehs;
_vehicles = _vehData select 0;
_groups = _vehData select 1;
_units = _vehData select 2;

_veh = (_vehData select 3) select 0;
[_veh,"AAF Convoy Escort"] spawn inmuneConvoy;

if !(_escortType in vehTank) then {
	_groupType = [infSquad, infTeam] select (_escortType in vehIFV);
	_groupType = [_groupType, side_green] call AS_fnc_pickGroup;

	_tempGroup = [_posbase, side_green, _groupType] call BIS_Fnc_spawnGroup;
	{[_x] spawn genInit;_x assignAsCargo _veh;_x moveInCargo _veh; _units pushBack _x; [_x] join ((_vehData select 3) select 0)} forEach units _tempGroup;
	deleteGroup _tempGroup;
	if (_escortType != enemyMotorpoolDef) then {
		[_veh] spawn smokeCover;
	};
};

[_vehData select 3] call _addWaypoint;

sleep 30;
{_x allowDamage true} forEach _vehicles;
{_x allowDamage true} forEach _units;

if (_convoyType == "HVT") then {
	_params = [vehicle _hvt, _vehicles, _posDestination]
} else {
	_params = [_vehObj, _vehicles, _posDestination]
};

_params spawn {
	params ["_obj", "_allVehicles", "_targetPosition"];
	private ["_objDriver","_curVeh","_groupVeh","_wp1","_danger"];

	_allVehicles = _allVehicles - [_obj];
	_objDriver = driver _obj;
	_danger = false;

	while {(alive _obj)} do {
		if (((!alive _objDriver) or (behaviour _objDriver == "COMBAT")) and !_danger) then {
			_danger = true;
			for "_i" from 0 to (count _allVehicles) - 1 do {
				_curVeh = _allVehicles select _i;
				_groupVeh = group (driver _curVeh);
				while {(count (waypoints _groupVeh)) > 0} do {
					deleteWaypoint ((waypoints _groupVeh) select 0);
				};
				_wp1 = _groupVeh addWaypoint [position _obj, 10];
				_wp1 setWaypointType "MOVE";
				_wp1 setWaypointBehaviour "AWARE";
				_groupVeh setBehaviour "AWARE";
				_curVeh limitSpeed 150;
			};
		};

		if (_danger) then {
			if ((alive _objDriver) and (vehicle _objDriver == _obj) and (behaviour _objDriver != "COMBAT")) then {
				_danger = false;
				for "_i" from 0 to (count _allVehicles) - 1 do {
					_curVeh = _allVehicles select _i;
					_groupVeh = group (driver _curVeh);
					while {(count (waypoints _groupVeh)) > 0} do {
						deleteWaypoint ((waypoints _groupVeh) select 0);
					};
					_wp1 = _groupVeh addWaypoint [_targetPosition, 10];
					_wp1 setWaypointType "MOVE";
					_wp1 setWaypointBehaviour "SAFE";
					_groupVeh setBehaviour "SAFE";
					_curVeh limitSpeed 50;
				};
			};
		};

		sleep 5;
	};
};

if (_convoyType == "HVT") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_hvt distance _posDestination < 100) or (not alive _hvt)};

	if ((_hvt distance _posDestination < 100) or (dateToNumber date > _endTimeNumber)) then {
		_tskOutcome = "FAILED";
		[-1200] remoteExec ["AS_fnc_increaseAttackTimer", 2];
		[-10,Slowhand] call playerScoreAdd;
	} else {
		_tskOutcome = "SUCCEEDED";
		[10,0] remoteExec ["prestige",2];
		[0,5,_posDestination] remoteExec ["AS_fnc_changeCitySupport",2];
		[1800] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_hvt,"BLUFORSpawn"] call distanceUnits);
		[5,Slowhand] call playerScoreAdd;
		[position _hvt] spawn patrolCA;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	};
};


if (_convoyType == "Municion") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};

	if ((_vehObj distance _posDestination < 100) or (dateToNumber date >_endTimeNumber)) then {
		_tskOutcome = "FAILED";
		[-1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		[-10,Slowhand] call playerScoreAdd;
		clearMagazineCargoGlobal _vehObj;
		clearWeaponCargoGlobal _vehObj;
		clearItemCargoGlobal _vehObj;
		clearBackpackCargoGlobal _vehObj;
	} else {
		_tskOutcome = "SUCCEEDED";
		[0,300] remoteExec ["resourcesFIA",2];
		[1800] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_vehObj,"BLUFORSpawn"] call distanceUnits);
		[5,Slowhand] call playerScoreAdd;
		[position _vehObj] spawn patrolCA;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	};
};

if (_convoyType == "Armor") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};

	if ((_vehObj distance _posDestination < 100) or (dateToNumber date > _endTimeNumber)) then {
		_tskOutcome = "FAILED";
		tanksAAFcurrent = tanksAAFcurrent + 1;
		server setVariable [_destination,dateToNumber date,true];
		[-1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		[-10,Slowhand] call playerScoreAdd;
	} else {
		_tskOutcome = "SUCCEEDED";
		[5,0] remoteExec ["prestige",2];
		[0,5,_posDestination] remoteExec ["AS_fnc_changeCitySupport",2];
		[2700] remoteExec ["AS_fnc_increaseAttackTimer",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_vehObj,"BLUFORSpawn"] call distanceUnits);
		[5,Slowhand] call playerScoreAdd;
		[position _vehObj] spawn patrolCA;
		// BE module
		if (activeBE) then {
			["mis"] remoteExec ["fnc_BE_XP", 2];
		};
		// BE module
	};
};

if (_convoyType == "Prisoners") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive driver _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false]) or ({alive _x} count _POWs == 0)};

	if ((_vehObj distance _posDestination < 100) or ({alive _x} count _POWs == 0) or (dateToNumber date > _endTimeNumber)) then {
		_tskOutcome = "FAILED";
		{_x setCaptive false} forEach _POWs;
		_counter = 2 * (count _POWs);
		[_counter,0] remoteExec ["prestige",2];
		[-10,Slowhand] call playerScoreAdd;
		};
	if ((not alive driver _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])) then {
		[position _vehObj] spawn patrolCA;
		{_x setCaptive false; _x enableAI "MOVE"; [_x] orderGetin false;} forEach _POWs;
		waitUntil {sleep 2; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance _posHQ < 50)} count _POWs > 0) or (dateToNumber date > _endTimeNumber)};

		if (({alive _x} count _POWs == 0) or (dateToNumber date > _endTimeNumber)) then {
			_tskOutcome = "FAILED";
			_counter = 2 * (count _POWs);
			[_counter,0] remoteExec ["prestige",2];
			[-10,Slowhand] call playerScoreAdd;
		} else {
			_tskOutcome = "SUCCEEDED";
			_counter = {(alive _x) and (_x distance _posHQ < 150)} count _POWs;
			_hr = _counter;
			_resourcesFIA = 300 * _counter;
			[_hr,_resourcesFIA] remoteExec ["resourcesFIA",2];
			[0,10,_posbase] remoteExec ["AS_fnc_changeCitySupport",2];
			[2*_counter,0] remoteExec ["prestige",2];
			{[_x] join _groupPOW; [_x] orderGetin false} forEach _POWs;
			{[_counter,_x] call playerScoreAdd} forEach (allPlayers - hcArray);
			[round (_counter/2),Slowhand] call playerScoreAdd;
			// BE module
			if (activeBE) then {
				["mis"] remoteExec ["fnc_BE_XP", 2];
			};
			// BE module
		};
	};
};

if (_convoyType == "Money") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};

	if ((dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive _vehObj)) then {
		_tskOutcome = "FAILED";
		if ((dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100)) then {
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF + 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[-1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
			[-10,Slowhand] call playerScoreAdd;
		} else {
			[position _vehObj] spawn patrolCA;
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[2700] remoteExec ["AS_fnc_increaseAttackTimer",2];
		};
	};

	if (driver _vehObj getVariable ["BLUFORSpawn",false]) then {
		[position _vehObj] spawn patrolCA;
		waitUntil {sleep 2; (_vehObj distance _posHQ < 50) or (not alive _vehObj) or (dateToNumber date > _endTimeNumber)};

		if ((not alive _vehObj) or (dateToNumber date > _endTimeNumber)) then {
			_tskOutcome = "FAILED";
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[1800] remoteExec ["AS_fnc_increaseAttackTimer",2];
		};

		if (_vehObj distance _posHQ < 50) then {
			_tskOutcome = "SUCCEEDED";
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[10,-20,_destination] remoteExec ["AS_fnc_changeCitySupport",2];
			[-20,0] remoteExec ["prestige",2];
			[0,5000] remoteExec ["resourcesFIA",2];
			[-1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
			{if (_x distance _vehObj < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
			[5,Slowhand] call playerScoreAdd;
			// BE module
			if (activeBE) then {
				["mis"] remoteExec ["fnc_BE_XP", 2];
			};
			// BE module
			waitUntil {sleep 1; speed _vehObj < 1};
			[_vehObj] call vaciar;
			deleteVehicle _vehObj;
		};
	};
	reportedVehs = reportedVehs - [_vehObj];
	publicVariable "reportedVehs";
};

if (_convoyType == "Supplies") then {
	waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};

	if (not alive _vehObj) then {
		[position _vehObj] spawn patrolCA;
		_tskOutcome = "FAILED";
		[-5,0] remoteExec ["prestige",2];
		[-10,Slowhand] call playerScoreAdd;
	};

	if ((dateToNumber date > _endTimeNumber) or (_vehObj distance _posDestination < 100) or (driver _vehObj getVariable ["BLUFORSpawn",false])) then {
		if (driver _vehObj getVariable ["BLUFORSpawn",false]) then {
			[position _vehObj] spawn patrolCA;
			waitUntil {sleep 1; (_vehObj distance _posDestination < 100) or (not alive _vehObj) or (dateToNumber date > _endTimeNumber)};

			if (_vehObj distance _posDestination < 100) then {
				_tskOutcome = "SUCCEEDED";
				[5,0] remoteExec ["prestige",2];
				[0,15,_destination] remoteExec ["AS_fnc_changeCitySupport",2];
				{if (_x distance _vehObj < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
				[5,Slowhand] call playerScoreAdd;
				// BE module
				if (activeBE) then {
					["mis"] remoteExec ["fnc_BE_XP", 2];
				};
				// BE module
			} else {
				_tskOutcome = "FAILED";
				[5,-10,_destination] remoteExec ["AS_fnc_changeCitySupport",2];
				[-5,0] remoteExec ["prestige",2];
				[-10,Slowhand] call playerScoreAdd;
				};
		} else {
			_tskOutcome = "FAILED";
			[2,0] remoteExec ["prestige",2];
			[15,0,_destination] remoteExec ["AS_fnc_changeCitySupport",2];
			[-10,Slowhand] call playerScoreAdd;
		};
	};
	reportedVehs = reportedVehs - [_vehObj];
	publicVariable "reportedVehs";
};

_tsk = ["CONVOY",[side_blue,civilian],[format [_tskDesc,_originName,numberToDate [2035,_startTimeNumber] select 3,numberToDate [2035,_startTimeNumber] select 4,_destinationName],format [_tskTitle, A3_Str_INDEP],_destination],_posDestination,_tskOutcome,5,true,true,_icon] call BIS_fnc_setTask;

{
	while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	};
	_wp0 = _x addWaypoint [_posbase, 0];
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointBehaviour "SAFE";
	_wp0 setWaypointSpeed "LIMITED";
	_wp0 setWaypointFormation "COLUMN";
} forEach _groups;

if (_convoyType == "Prisoners") then {
	{
		deleteVehicle _x;
	} forEach _POWs;
};

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};

if (_source == "civ") then {
	_val = server getVariable "civActive";
	server setVariable ["civActive", _val - 1, true];
};

[600,_tsk] spawn borrarTask;

{
	waitUntil {sleep 1; (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
	deleteVehicle _x;
} forEach _units;

{
	if (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x}
} forEach _vehicles;

{deleteGroup _x} forEach _groups;