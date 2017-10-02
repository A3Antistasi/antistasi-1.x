params ["_marker"];
private ["_markerPos","_respawnDelay","_respawnTime","_nearestLocation"];

_markerPos = getMarkerPos (_marker);

_respawnDelay = 120;
_respawnTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _respawnDelay];
_respawnTime = dateToNumber _respawnTime;

waitUntil {sleep 60; (dateToNumber date > _respawnTime)};
_nearestLocation = [markers,_markerPos] call BIS_fnc_nearestPosition;
if (_nearestLocation in mrkAAF) then {
	mrkAAF = mrkAAF + [_marker];
	mrkFIA = mrkFIA - [_marker];
	publicVariable "mrkAAF";
	publicVariable "mrkFIA";
};