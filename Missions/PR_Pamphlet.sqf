if (!isServer and hasInterface) exitWith {};

params ["_marker"];
[3,[],[],[],[],[]] params ["_countBuildings","_targetBuildings","_allGroups","_allSoldiers","_allVehicles","_leafletCrates"];
private ["_targetPosition","_targetName","_duration","_endTime","_task","_spawnPosition","_missionVehicle","_crate","_range","_allBuildings","_usableBuildings","_index","_perimeterBuildings","_currentBuilding","_lastBuilding","_bPositions","_groupType","_params","_group","_dog","_leaflets","_drop"];

_tskTitle = localize "STR_TSK_PRPAMPHLET";
_tskDesc = localize "STR_TSKDESC_PRPAMPHLET";
_tskDesc_fail = localize "STR_TSKDESC_PRPAMPHLET_FAIL";
_tskDesc_drop = localize "STR_TSKDESC_PRPAMPHLET_DROP";
_tskDesc_success = localize "STR_TSKDESC_PRPAMPHLET_SUCCESS";

_targetPosition = getMarkerPos _marker;
_targetName = [_marker] call AS_fnc_localizar;
_range = [_marker] call sizeMarker;

_allBuildings = nearestObjects [_targetPosition, ["Building"], _range];
if (count _allBuildings < 3) then {
	while {(_range < 1000) AND (count _allBuildings < 3)} do {
		_range = _range + 100;
		_allBuildings = nearestObjects [_targetPosition, ["Building"], _range];
	};
};

if (count _allBuildings < 3) exitWith {};

_duration = 60;
_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;

_task = ["PR",[side_blue,civilian],[format [_tskDesc,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetPosition,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _task; publicVariable "misiones";

_spawnPosition = (getMarkerPos guer_respawn) findEmptyPosition [5,50,"C_Van_01_transport_F"];
if !(count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
	if (count (_spawnPosition nearObjects ["AllVehicles",7]) > 0) then {
		_spawnPosition = (server getVariable ["obj_vehiclePad",[]]);
	};
};

_missionVehicle = "C_Van_01_transport_F" createVehicle _spawnPosition;

_missionVehicle lockCargo true;
{_missionVehicle lockCargo [_x, false];} forEach [0 ,1];

_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
_crate attachTo [_missionVehicle,[0,-2.5,-0.25]];
_crate setDir (getDir _missionVehicle + 78);
_leafletCrates pushBackUnique _crate;

_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
_crate attachTo [_missionVehicle,[0.4,-1.1,-0.25]];
_crate setDir (getDir _missionVehicle);
_leafletCrates pushBackUnique _crate;

_crate = "Land_WoodenCrate_01_F" createVehicle [0,0,0];
_crate attachTo [_missionVehicle,[-0.4,-1.1,-0.25]];
_crate setDir (getDir _missionVehicle);
_leafletCrates pushBackUnique _crate;

[_missionVehicle] spawn VEHinit;
{_x reveal _missionVehicle} forEach (allPlayers - entities "HeadlessClient_F");
_missionVehicle setVariable ["tmp_targetName",_targetName,true];
_missionVehicle addEventHandler ["GetIn", {
	if (_this select 1 == "driver") then {
		format ["This truck carries leaflets for %1.",(_this select 0) getVariable ["tmp_targetName","Llandudno"]] remoteExec ["hint",_this select 2];
	};
}];

_allVehicles pushBack _missionVehicle;

[_missionVehicle,"Mission Vehicle"] spawn inmuneConvoy;

_usableBuildings =+ _allBuildings;

_index = round (3* ((count _allBuildings) /4));
_perimeterBuildings = [_allBuildings, _index] call BIS_fnc_subSelect;

if (count _perimeterBuildings < 3) then {
	_perimeterBuildings =+ _allBuildings;
};

while {(count _targetBuildings < 1) AND (count _perimeterBuildings > 0)} do {
	_currentBuilding = selectRandom _perimeterBuildings;
	_bPositions = [_currentBuilding] call BIS_fnc_buildingPositions;
	if (count _bPositions > 1) then {
		_targetBuildings pushBackUnique _currentBuilding;
		_lastBuilding = _currentBuilding;
	};
	_usableBuildings = _usableBuildings - [_currentBuilding];
	_perimeterBuildings = _perimeterBuildings - [_currentBuilding];
};

while {(count _targetBuildings < _countBuildings) AND (count _usableBuildings > 0)} do {
	_currentBuilding = selectRandom _usableBuildings;
	_bPositions = [_currentBuilding] call BIS_fnc_buildingPositions;
	if (((position _lastBuilding distance position _currentBuilding) > 100) AND (count _bPositions > 1)) then {
		_targetBuildings pushBackUnique _currentBuilding;
		_lastBuilding = _currentBuilding;
	};
	_usableBuildings = _usableBuildings - [_currentBuilding];
};

if (count _targetBuildings < 3) then {
	while {(count _targetBuildings < 3) AND (count _allBuildings > 1)} do {
		_currentBuilding = selectRandom _allBuildings;
		_targetBuildings pushBackUnique _currentBuilding;
		_allBuildings = _allBuildings - [_currentBuilding];
	};
};

_groupType = [infGarrisonSmall, side_green] call AS_fnc_pickGroup;
_params = [_targetPosition, side_green, _groupType];

for "_i" from 0 to 1 do {
	_group = _params call BIS_Fnc_spawnGroup;
	sleep 1;
	_dog = _group createUnit ["Fin_random_F",_targetPosition,[],0,"FORM"];
	[_dog] spawn guardDog;
	[leader _group, _marker, "SAFE", "RANDOM", "SPAWNED","NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBack _group;
};

{
	_group = _x;
	{
		[_x] spawn genInitBASES;
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups;

// wait until the vehicle enters the target area
waitUntil {sleep 1; !(alive _missionVehicle) OR (dateToNumber date > _endTime) OR (_missionVehicle distance _targetPosition < 500)};


// vehicle destroyed or timer ran out
if !(_missionVehicle distance _targetPosition < 550) exitWith {
	_task = ["PR",[side_blue,civilian], [format [_tskDesc_fail, _targetName],_tskTitle,_marker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
    [5,-5,_targetPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;

    [1200,_task] spawn borrarTask;
	waitUntil {sleep 1; !([distanciaSPWN,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) OR ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) AND (speed _missionVehicle < 1))};
	if ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) AND (speed _missionVehicle < 1)) then {
		[_missionVehicle,true] call vaciar;
	};
	{deleteVehicle _x} forEach _leafletCrates;
	[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;
};

// eye candy
_leaflets =
[
	["Land_Garbage_square3_F",[2.92334,0.0529785,0],360,1,0.0128296,[-0.000179055,0.000127677],"","",true,false],
	["Land_Leaflet_02_F",[2.66357,0.573486,0.688],36.0001,1,0,[-89.388,90],"","",true,false],
	["Land_Leaflet_02_F",[2.76953,0.0114746,0.688],152,1,0,[-88.513,-90],"","",true,false],
	["Land_Leaflet_02_F",[2.81738,-0.317627,0.688],8.00002,1,0,[-89.19,90],"","",true,false],
	["Land_WoodenCrate_01_F",[2.92334,0.0529785,0],360,1,0.0128296,[-0.000179055,0.000127677],"","",true,false],
	["Land_Leaflet_02_F",[2.91455,0.409424,0.688],0.999995,1,0,[-86.6,90],"","",true,false],
	["Land_Leaflet_02_F",[3.06543,0.0744629,0.688],309,1,0,[-89.19,90],"","",true,false],
	["Land_Leaflet_02_F",[3.1377,0.481445,0.688],312,1,0,[-89.19,90],"","",true,false]
];

/*
	_proceed: proceeded to the next site
	_timerRunning: timer running
	_unloading: unloading
	_deploymentTime: time it takes to unload the gear (seconds)
	_counter: running timer
	_currentDropCount: number of sites done
	_currentDrop: current site
	_canUnload: flag to control unloading action

	pr_unloading_pamphlets: active process
*/
[false,false,false,false,60,0,0,""] params ["_proceed","_timerRunning","_unloading","_canUnload","_deploymentTime","_counter","_currentDropCount","_currentDrop"];

server setVariable ["pr_unloading_pamphlets", false, true];

// truck alive, mission running, sites to go
while {(alive _missionVehicle) AND (dateToNumber date < _endTime) AND (_currentDropCount < 3)} do {

	// advance site, refresh task
	if !(_proceed) then {
		_proceed = true;
		_currentDrop = _targetBuildings select _currentDropCount;
		_task = ["PR",[side_blue,civilian],[format [_tskDesc_drop,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker], position _currentDrop,"ASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;

		_patGroup = _allGroups select 0;
		if (((leader _patGroup) distance2D (position _currentDrop)) > ((leader (_allGroups select 1)) distance2D (position _currentDrop))) then {
			_patGroup = _allGroups select 1;
		};
		if (alive leader _patGroup) then {
			_wp101 = _patGroup addWaypoint [position _currentDrop, 20];
			_wp101 setWaypointType "SAD";
			_wp101 setWaypointBehaviour "AWARE";
			_patGroup setCombatMode "RED";
			_patGroup setCurrentWaypoint _wp101;
		};
	};

	// truck close enough to unload
	while {(alive _missionVehicle) AND (dateToNumber date < _endTime) AND (_currentDropCount < 3) AND (_currentDrop distance _missionVehicle < 20)} do {

		// add unload action if truck is stationary
		if (!(_canUnload) AND (speed _missionVehicle < 1)) then {
			_canUnload = true;
			[_missionVehicle,"unload_pamphlets"] remoteExec ["AS_fnc_addActionMP"];
		};

		// stop unloading when enemies get too close
		while {(_counter < _deploymentTime) AND (alive _missionVehicle) AND !({_x getVariable ["inconsciente",false]} count ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits)) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits == 0) AND (dateToNumber date < _endTime) AND (server getVariable "pr_unloading_pamphlets")} do {

			// spawn eye candy
			if !(_unloading) then {
				_unloading = true;
				_spawnPosition = (position _missionVehicle) findEmptyPosition [1,10,"C_Van_01_transport_F"];
				_drop = [_spawnPosition, random 360, _leaflets] call BIS_fnc_ObjectsMapper;
				_allVehicles = _allVehicles + _drop;
				[_leafletCrates select _currentDropCount, {deleteVehicle _this}] remoteExec ["call", 0];
			};

			// start a progress bar, remove crew from truck, lock the truck
			if !(_timerRunning) then {
				{if (isPlayer _x) then {[(_deploymentTime - _counter),false] remoteExec ["pBarMP",_x]; [_missionVehicle,true] remoteExec ["AS_fnc_lockVehicle",_x];}} forEach ([80,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);
				_timerRunning = true;
				[petros,"globalChat","Guard the truck!"] remoteExec ["commsMP"];
				{
					_x action ["eject", _missionVehicle];
				} forEach (crew (_missionVehicle));
				[_missionVehicle, true] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
				_missionVehicle lock 2;
				_missionVehicle engineOn false;
				switch (_currentDropCount) do
					{
						case 0: { {_missionVehicle lockCargo [_x, false];} forEach [8, 9, 10, 11];};
						case 1: { {_missionVehicle lockCargo [_x, false];} forEach [3, 5, 7];};
						case 2: { _missionVehicle lockCargo false};
					};
			};

			_counter = _counter + 1;
  			sleep 1;
		};

		// if unloading wasn't finished, reset
		if ((_counter < _deploymentTime) AND (server getVariable "pr_unloading_pamphlets")) then {
			_counter = 0;
			_timerRunning = false;
			_missionVehicle lock 0;
			[_missionVehicle, false] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
			{if (isPlayer _x) then {[0,true] remoteExec ["pBarMP",_x]}} forEach ([100,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);

			if ((!([80,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) OR ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits != 0)) AND (alive _missionVehicle)) then {
				{if (isPlayer _x) then {[petros,"hint","Stay near the truck, keep the perimeter clear of hostiles."] remoteExec ["commsMP",_x]}} forEach ([150,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);
			};

			waitUntil {sleep 1; (!alive _missionVehicle) OR (([80,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits) AND ({((side _x == side_green) OR (side _x == side_red)) AND (_x distance _missionVehicle < 50)} count allUnits == 0)) OR (dateToNumber date > _endTime)};
		};

		// if unloading was finished, reset all respective flags, escape to the outer loop
		if ((alive _missionVehicle) AND !(_counter < _deploymentTime)) exitWith {
			_info = "";
			server setVariable ["pr_unloading_pamphlets", false, true];
			_canUnload = false;
			[[_missionVehicle,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			_counter = 0;
			[_missionVehicle, false] remoteExec ["AS_fnc_lockVehicle", [0,-2] select isDedicated,true];
			_missionVehicle lock 0;
			_proceed = false;
			_timerRunning = false;
			_unloading = false;
			_currentDropCount = _currentDropCount + 1;

			// if there are sites to go, inform player
			if (_currentDropCount < 3) then {
				_info = "Head to the next location.";
				{if (isPlayer _x) then {[petros,"hint",_info] remoteExec ["commsMP",_x]}} forEach ([150,0,_missionVehicle,"BLUFORSpawn"] call distanceUnits);
			};
		};
		sleep 1;
	};

	// remove unload action if truck isn't close enough to current site
	if (_canUnload) then {
		_canUnload = false;
		[_missionVehicle,"remove"] remoteExec ["AS_fnc_addActionMP"];
	};
	sleep 1;
};

// fail if the truck is destroyed or the timer runs out
if (!(alive _missionVehicle) OR (dateToNumber date > _endTime)) then {
	_task = ["PR",[side_blue,civilian], [format [_tskDesc_fail, _targetName],_tskTitle,_marker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[0,-2,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
} else {
	_task = ["PR",[side_blue,civilian], [format [_tskDesc_success,_targetName,numberToDate [2035,_endTime] select 3,numberToDate [2035,_endTime] select 4],_tskTitle,_marker],_targetPosition,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[-15,5,_marker] remoteExec ["AS_fnc_changeCitySupport",2];
	[5,0] remoteExec ["prestige",2];
	{if (_x distance _targetPosition < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

[1200,_task] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_missionVehicle,"BLUFORSpawn"] call distanceUnits)) or ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) && (speed _missionVehicle < 1))};
if ((_missionVehicle distance (getMarkerPos guer_respawn) < 60) && (speed _missionVehicle < 1)) then {
	[_missionVehicle,true] call vaciar;
};
{deleteVehicle _x} forEach _leafletCrates;
sleep 1;
deleteVehicle _missionVehicle;

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;