params ["_marker", "_roadblock"];
private ["_nearestMarker","_position"];

_position = getMarkerPos _roadblock;

_nearestMarker = [markers,_position] call BIS_fnc_nearestPosition;

if (_nearestMarker == _marker) then {
	waitUntil {sleep 1;(spawner getVariable _roadblock == 4)};
	mrkAAF = mrkAAF - [_roadblock];
	mrkFIA = mrkFIA + [_roadblock];
	publicVariable "mrkAAF";
	publicVariable "mrkFIA";
};