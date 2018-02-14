if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_DEFCAMP";
_tskDesc = "STR_TSK_TD_DESC_DEFCAMP";

if (server getVariable ["active_campQRF", false]) exitWith {};
if (server getVariable ["blockCSAT", false]) exitWith {};
if ("DEF" in misiones) exitWith {};

server setVariable ["active_campQRF", true, true];

params ["_targetMarker"];
["",[],"",[],"","small"] params ["_campName","_airports","_airport","_posAirport","_airportName","_QRFsize"];
private ["_targetPosition","_airportsAAF"];

#define DURATION 15

_targetPosition = getMarkerPos _targetMarker;

for "_i" from 0 to (count campList - 1) do {
	if ((campList select _i) select 0 == _targetMarker) exitWith {
		_campName = (campList select _i) select 1;
	};
};

_airportsAAF = aeropuertos - mrkFIA;
{
	_airport = _x;
	_posAirport = getMarkerPos _airport;
	if ((_targetPosition distance _posAirport < 10000) and (_targetPosition distance _posAirport > 1500) and (not (spawner getVariable _airport))) then {_airports = _airports + [_airport]}
} forEach _airportsAAF;
if (count _airports > 0) then {
	_airport = [_airports, _targetPosition] call BIS_fnc_nearestPosition;
	_posAirport = getMarkerPos _airport;
	_airportName = [_airport] call AS_fnc_localizar;
} else {
	_airport = "spawnCSAT";
	_airportName = format ["the %1 carrier",A3_Str_RED];
};

_tsk = ["DEF_Camp",[side_blue,civilian],[[_tskDesc, _campName, _airportName],[_tskTitle, _campName],_targetMarker],_targetPosition,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

if (isMultiplayer) then {
	if (count (allPlayers - entities "HeadlessClient_F") > 3) then {
		_QRFsize = "large";
	};
};

[_airport, _targetPosition, _targetMarker, DURATION, "transport", _QRFsize, "campQRF", "campQRF"] remoteExec ["enemyQRF",  call AS_fnc_getNextWorker];

waitUntil {sleep 3; (server getVariable ["campQRF", false]) OR {!(_targetMarker in campsFIA)}};

if (_targetMarker in campsFIA) then {
	_tsk = ["DEF_Camp",[side_blue,civilian],[[_tskDesc, _campName, _airportName],[_tskTitle, _campName],_targetMarker],_targetPosition,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	[0,0] remoteExec ["prestige",2];
	[0,300] remoteExec ["resourcesFIA",2];
	[5,Slowhand] call playerScoreAdd;
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_targetPosition,"BLUFORSpawn"] call distanceUnits);
} else {
	_tsk = ["DEF_Camp",[side_blue,civilian],[[_tskDesc, _campName, _airportName],[_tskTitle, _campName],_targetMarker],_targetPosition,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
};

server setVariable ["campQRF", false, true];
server setVariable ["active_campQRF", false, true];

[1200,_tsk] spawn borrarTask;
