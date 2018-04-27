if (!isServer and hasInterface) exitWith{};

_tskTitle = "STR_TSK_TD_PRBrain";
_tskDesc = "STR_TSK_TD_DESC_PRBrain";
_tskDesc_fail = "STR_TSK_TD_DESC_PRBrain_fail";
_tskDesc_fail2 = "STR_TSK_TD_DESC_PRBrain_fail2";
_tskDesc_hold = "STR_TSK_TD_DESC_PRBrain_hold";
_tskDesc_success = "STR_TSK_TD_DESC_PRBrain_success";

/*
parameters
0: target marker (marker)
*/
_targetMarker = _this select 0;
_targetPosition = getMarkerPos _targetMarker;
_targetName = [_targetMarker] call AS_fnc_localizar;

// mission timer
_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_tsk = ["PR",[side_blue,civilian],[[_tskDesc,_targetName,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_targetMarker],_targetPosition,"CREATED",5,true,true,"Heal"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";


// find bases and airports to serve as spawnpoints for reinforcements
_basesAAF = bases - mrkFIA;
_bases = [];
_base = "";
{
	_base = _x;
	_posBase = getMarkerPos _base;
	if ((_targetPosition distance _posBase < 7500) and (_targetPosition distance _posBase > 1500) and !(spawner getVariable _base)) then {
		if (worldName == "Tanoa") then {
			if ([_posBase, _targetPosition] call AS_fnc_IslandCheck) then {_bases pushBack _base};
		} else {
			_bases pushBack _base;
		};
	};
} forEach _basesAAF;
if (count _bases > 0) then {_base = [_bases,_targetPosition] call BIS_fnc_nearestPosition;} else {_base = ""};

_posBase = getMarkerPos _base;

_airportsAAF = aeropuertos - mrkFIA;
_airports = [];
_airport = "";
_posAirport = [];
{
	_airport = _x;
	_posAirport = getMarkerPos _airport;
	if ((_targetPosition distance _posAirport < 7500) and (_targetPosition distance _posAirport > 1500) and (not (spawner getVariable _airport))) then {_airports = _airports + [_airport]}
} forEach _airportsAAF;
if (count _airports > 0) then {_airport = [_airports, _targetPosition] call BIS_fnc_nearestPosition; _posAirport = getMarkerPos _airport;} else {_airport = ""};

// spawn mission vehicle
propTruck = "";
_pos = (getMarkerPos guer_respawn) findEmptyPosition [10,50,"C_Truck_02_box_F"];
propTruck = "C_Truck_02_box_F" createVehicle _pos;
propTruck allowDamage false;
[propTruck] spawn {sleep 1; (_this select 0) allowDamage true;};

// spawn eye candy
_grafArray = [];
_graf1 = "Land_Graffiti_02_F" createVehicle _pos;
_graf1 attachTo [propTruck,[-1.32,-2.5,-0.15]];
_graf1 setDir (getDir propTruck + 90);
_grafArray pushBack _graf1;

_graf2 = "Land_Graffiti_05_F" createVehicle _pos;
_graf2 attachTo [propTruck,[-1.32,0.6,-0.5]];
_graf2 setDir (getDir propTruck + 90);
_grafArray pushBack _graf2;

_graf3 = "Land_Graffiti_05_F" createVehicle _pos;
_graf3 attachTo [propTruck,[1.32,0.6,-0.5]];
_graf3 setDir (getDir propTruck + 270);
_grafArray pushBack _graf3;

_graf4 = "Land_Graffiti_03_F" createVehicle _pos;
_graf4 attachTo [propTruck,[1.32,-2.5,-0.15]];
_graf4 setDir (getDir propTruck + 270);
_grafArray pushBack _graf4;

// initialize mission vehicle
[propTruck] spawn VEHinit;
{_x reveal propTruck} forEach (allPlayers - (entities "HeadlessClient_F"));
propTruck setVariable ["destino",_targetName,true];
propTruck addEventHandler ["GetIn",
	{
	if (_this select 1 == "driver") then {
		_texto = format ["Bring this gear to %1",(_this select 0) getVariable "destino"];
		_texto remoteExecCall ["hint",_this select 2];
	};
	}
];

[propTruck,"Mission Vehicle"] spawn inmuneConvoy;

// set the flags for active item and active broadcast
server setVariable ["activeItem", propTruck, true];
server setVariable ["BCactive", false, true];

// dispatch a small QRF
if !(_airport == "") then {
	[_airport, _targetPosition, _targetMarker, _tiempolim, "transport", "small"] remoteExec ["enemyQRF", call AS_fnc_getNextWorker];
}
else {
	[_base, _targetPosition, _targetMarker, _tiempolim, "transport", "small"] remoteExec ["enemyQRF", call AS_fnc_getNextWorker];
};

// wait until the truck is in the target area or dead
waitUntil {sleep 1; (not alive propTruck) or (dateToNumber date > _fechalimnum) or (propTruck distance _targetPosition < 150)};

/*
condition flags for the loop
_break: fail the mission
_active: can activate the device
*/
_break = false;
_active = false;

// once the vehicle has arrived at its destination and is stationary, enable the activation action
while {(alive propTruck) && (dateToNumber date < _fechalimnum) && !(server getVariable "BCactive")} do {

	while {(alive propTruck) && (dateToNumber date < _fechalimnum) && (propTruck distance _targetPosition < 150) && !(server getVariable "BCactive")} do {
		if (!(_active) && (speed propTruck < 1)) then {
			_active = true;
			[[propTruck,"toggle_device"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			server setVariable ["BCdisabled", false, true];
		};
		if ((_active) && (speed propTruck > 1)) then {
			_active = false;
			[[propTruck,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
			server setVariable ["BCdisabled", true, true];
		};
		sleep 1;
	};
	sleep 1;
};

// if the device hasn't been activated, the mission failed
if !(server getVariable "BCactive") then {
	_break = true;
};

if (_break) exitWith {
	_tsk = ["PR",[side_blue,civilian],[[_tskDesc_fail,_targetName,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_targetMarker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_targetMarker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;

	[1200,_tsk] spawn borrarTask;

	waitUntil {sleep 1;(!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
	deleteVehicle propTruck;
	{
		deleteVehicle _x;
	} foreach _grafArray;
};

// create & spawn the propaganda site
_PRsite =
[
	["Land_BagFence_Round_F",[1.57227,1.87622,-0.00130129],99.7986,1,0,[0,-0],"","",true,false],
	["Land_Sacks_heap_F",[2.81982,-0.622803,0],323.257,1,0,[0,0],"","",true,false],
	["Land_Loudspeakers_F",[3.146,0.9729,0],0,1,0,[0,0],"","",true,false],
	["Land_PortableLight_single_F",[3.54053,-2.40137,0],228.698,1,0,[0,0],"","",true,false],
	["Land_Leaflet_02_F",[4.14307,-1.47192,0.688],183.52,1,0,[-90,-90],"","",true,false],
	["Land_Leaflet_02_F",[4.1499,-1.65796,0.688],180,1,0,[-90,-90],"","",true,false],
	["Land_WoodenBox_F",[4.52734,0.615967,4.76837e-007],152.102,1,0,[6.94714e-005,1.89471e-005],"","",true,false],
	["Land_Leaflet_02_F",[4.2959,-1.56104,0.688],198.517,1,0,[-90,-90],"","",true,false],
	["Land_Leaflet_02_F",[4.27979,-1.82007,0.688],216.361,1,0,[-90,-90],"","",true,false],
	["Land_Leaflet_02_F",[4.49463,-1.39014,0.688],156.16,1,0,[-90,-90],"","",true,false],
	["Land_WoodenCrate_01_F",[4.44775,-1.86304,4.76837e-007],0.000621233,1,0.0256633,[-5.14494e-005,-0.000126096],"","",true,false],
	["Land_WoodenBox_F",[4.82568,0.0627441,0],329.984,1,0,[-4.90935e-005,1.14739e-006],"","",true,false],
	["Land_BagFence_Round_F",[3.896,3.3252,-0.00130129],193.76,1,0,[0,0],"","",true,false],
	["Land_Leaflet_02_F",[4.58105,-1.7041,0.688],127.235,1,0,[-90,-90],"","",true,false],
	["Land_WoodenCrate_01_stack_x3_F",[3.84229,-3.79712,0],0,1,0,[0,0],"","",true,false],
	[guer_flag,[5.04297,-2.52319,0],0,1,0,[0,0],"","",true,false],
	["Land_Sacks_heap_F",[6.08154,1.64722,0],27.137,1,0,[0,0],"","",true,false],
	["Land_PortableLight_single_F",[5.90527,2.94946,0],18.0931,1,0,[0,0],"","",true,false],
	["Land_Graffiti_05_F",[6.84229,-0.0407715,2.28578],128.676,1,0,[0,-0],"","",true,false],
	["SignAd_SponsorS_F",[6.84619,-0.0651855,6.67572e-006],130.045,1,0,[0,-0],"","",true,false]
];

_posSiteBackup = (position propTruck) findEmptyPosition [1,25,"I_MBT_03_cannon_F"];
_posSite = [position propTruck, 0, 20, 2, 0, 0.3, 0, [], [_posSiteBackup,[]]] call BIS_Fnc_findSafePos;
_objectsToDelete = [_posSite, random 360, _PRsite] call BIS_fnc_ObjectsMapper;

// remove crew from the truck, lock it, turn off the engine
{
	_x action ["eject", propTruck];
} forEach (crew (propTruck));
propTruck lock 2;
propTruck engineOn false;

// reveal the truck's location to all nearby enemies, blow the cover of all nearby friendlies
{
	_amigo = _x;
	if (captive _amigo) then {
		[_amigo,false] remoteExec ["setCaptive",_amigo];
	};
	{
		if ((side _x == side_green) and (_x distance propTruck < distanciaSPWN)) then {
			if (_x distance propTruck < 300) then {_x doMove position propTruck} else {_x reveal [_amigo,4]};
		};
	} forEach allUnits;
} forEach ([300,0,propTruck,"BLUFORSpawn"] call distanceUnits);

/*
trigger the attack waves
parameters:
_timing: launch of a specific wave, time in minutes after the activation of the device
_comp: type of wave, see attackWaves.sqf for details

default setting based on number of players online
*/
_timing = [5,10,16];
_comp = ["QRF_air_mixed_small", "QRF_land_mixed_small", "CSAT_small"];
if (isMultiplayer) then {
	_timing = [0,5,10,20];
	_comp = ["QRF_air_mixed_small", "QRF_land_mixed_large", "QRF_land_transport_large","CSAT_small"];
	if (count (allPlayers - entities "HeadlessClient_F") > 3) then {
		_timing = [0,1,4,8,15,16,25];
		_comp = ["QRF_land_mixed_large", "QRF_air_mixed_small", "QRF_land_transport_large", "QRF_air_transport_large", "QRF_land_mixed_large", "QRF_air_mixed_large","CSAT_large"];
	};
};

0 = [_targetMarker, 30, _timing, _comp] spawn attackWaves;

_tsk = ["PR",[side_blue,civilian],[[_tskDesc_hold,_targetName,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_targetMarker],propTruck,"ASSIGNED",5,true,true,"Heal"] call BIS_fnc_setTask;

/*
setup for the progress bar/timer
parameters:
_duration: maximum duration for determining the reward
_counter: counts current duration
_active: flag for running counter
*/
_duration = 2400;
_counter = 0;
_active = false;

// truck is alive, deployed, timer below maximum, conscious players within 250m
while {(server getVariable "BCactive") && (alive propTruck) && ({(side _x isEqualTo side_blue) && (_x distance propTruck < 300)} count allPlayers > 0) && (_counter < _duration)} do {

	// alive, deployed, timer below maximum, blufor alive, no opfor/greenfor, conscious players within 250m
	while {(server getVariable "BCactive") &&
	(alive propTruck) &&
	!({[_x] call AS_fnc_isUnconscious} count ([300,0, propTruck,"BLUFORSpawn"] call distanceUnits) == count ([300,0, propTruck,"BLUFORSpawn"] call distanceUnits)) &&
	({((side _x == side_green) || (side _x == side_red)) && (_x distance propTruck < 50)} count allUnits == 0)} do {

		// activate the timer
		if !(_active) then {
			_active = true;
			[[petros,"globalChat","Hold this position for as long as you can! They will throw a lot at you, so be prepared!"],"commsMP"] call BIS_fnc_MP;
		};

		// timer display as hints
		_info = format ["Timer is at: %1", _counter];
		//{if (isPlayer _x) then {[petros,"hint", _info] remoteExec ["commsMP",_x]}} forEach ([300,0,propTruck,"BLUFORSpawn"] call distanceUnits);
		{
			if (isPlayer _x) then {
				// warn players at the edge of the area to not stray too far
					if ((_x distance propTruck) > 250 && (_x distance propTruck) <600) then
 				 	{ _info = "Stay within 250m of the station!";};
				[petros,"hint", _info] remoteExec ["commsMP",_x];
			};
		} forEach (allPlayers - entities "HeadlessClient_F");

		_counter = _counter + 1;
		sleep 1;
	};

	// suspend the timer when enemies breach the perimeter
	if (_counter < _duration) then {
		_active = false;

		if (({((side _x == side_green) || (side _x == side_red)) && (_x distance propTruck < 50)} count allUnits != 0) and (alive propTruck)) then {[[petros,"hint","Hostile forces near the terminal!"],"commsMP"] call BIS_fnc_MP};

		waitUntil {sleep 1; (!alive propTruck) || !(server getVariable "BCactive") || ({(side _x == side_green) and (_x distance propTruck < 50)} count allUnits == 0)};
	};
};

// stop the attack script from spawning additional waves
server setVariable ["waves_active", false, true];

/*
10 city support at 10 minutes, plus 1 support for every additional 80 seconds IF the timer was completed or the gear was deactivated manually
parameters:
_minTimer: minimum number of seconds before players can get any reward
_prestige: minimum additional city support for surpassing the minTimer
*/
_minTimer = 600;
_prestige = 0;
if (_counter < _minTimer) then {
	_break = true;
}
else {
	_prestige = 10 + floor ((_counter - _minTimer) / 80);
};

// inform players about timer at the end of the mission
_info = format ["You held the area clear for %1 minutes and %2 seconds.", floor (_counter / 60), _counter mod 60];
if (_break) then {
	_info = format ["You held the area clear for only %1 minutes and %2 seconds.", floor (_counter / 60), _counter mod 60];
};
{if (isPlayer _x) then {[petros,"hint", _info] remoteExec ["commsMP",_x]}} forEach ([300,0,propTruck,"BLUFORSpawn"] call distanceUnits);


// failure if you held out for less than 10 minutes
if (_break) then {
	_tsk = ["PR",[side_blue,civilian],[[_tskDesc_fail2,_targetName,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_targetMarker],_targetPosition,"FAILED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[5,-5,_targetMarker] remoteExec ["AS_fnc_changeCitySupport",2];
	[-10,Slowhand] call playerScoreAdd;
}
else {
	_tsk = ["PR",[side_blue,civilian],[[_tskDesc_success,_targetName,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_targetMarker],_targetPosition,"SUCCEEDED",5,true,true,"Heal"] call BIS_fnc_setTask;
	[0,_prestige,_targetMarker] remoteExec ["AS_fnc_changeCitySupport",2];
	{if (_x distance _targetPosition < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[10,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
};

[1200,_tsk] spawn borrarTask;

waitUntil {sleep 1;(!([distanciaSPWN,1,propTruck,"BLUFORSpawn"] call distanceUnits))};
deleteVehicle propTruck;

{
	deleteVehicle _x;
} foreach _grafArray;

// remove the propaganda site
waitUntil {sleep 1; (not([distanciaSPWN,1,_targetPosition,"BLUFORSpawn"] call distanceUnits))};
{
	deleteVehicle _x;
} foreach _objectsToDelete;


// reset the flag for active attack-spawning objects
server setVariable ["activeItem", nil, true];