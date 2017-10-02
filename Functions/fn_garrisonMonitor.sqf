params ["_marker", ["_garrison", []]];
private ["_sizeZone", "_sizeGarrison", "_markerPosition", "_break"];

if !(_marker in mrkAAF) exitWith {diag_log format ["Garrison monitor: invalid marker: %1", _marker]};
if (count _garrison == 0) exitWith {diag_log format ["Garrison monitor: invalid garrison: %1", _garrison]};
if !(spawner getVariable _marker) exitWith {diag_log format ["Garrison monitor: zone is inactive: %1", _marker]};

sleep 15; // allow units to spawn in properly

_sizeZone = [_marker] call sizeMarker;
_sizeGarrison = count _garrison;
_markerPosition = getMarkerPos _marker;
_break = false;

while {(spawner getVariable _marker)} do {
	if ( 3*({(alive _x) and !(captive _x) and (_x distance2d _markerPosition < 2*_sizeZone)} count _garrison) < (2* _sizeGarrison)) exitWith {
		reducedGarrisons pushBackUnique _marker;
		publicVariable "reducedGarrisons";
	};

	if (_marker in mrkFIA) exitWith {diag_log format ["Garrison monitor: zone was conquered: %1", _marker]};

	sleep 10;
};

sleep 2;

if (!(_marker in mrkFIA) and (_marker in reducedGarrisons)) exitWith {
	diag_log format ["Garrison monitor: garrison combat ineffective: %1 -- dispatching reinforcements", _marker];
	[_marker] spawn AS_fnc_reinforcementTimer;
};