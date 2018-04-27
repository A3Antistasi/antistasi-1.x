params ["_marker", "_roadblock"];
private ["_nearestMarker","_position"];

_position = getMarkerPos _roadblock;

_nearestMarker = [markers,_position] call BIS_fnc_nearestPosition;

if (_nearestMarker == _marker) then {
	waitUntil {sleep 1;not (spawner getVariable _roadblock)};
	mrkAAF = mrkAAF - [_roadblock];
	mrkFIA = mrkFIA + [_roadblock];
	publicVariable "mrkAAF";
	publicVariable "mrkFIA";
};