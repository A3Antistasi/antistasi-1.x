params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration", "_type"];

private _infGroup1 = _infGroups;
private _infGroup2 = "";
private _wpPos = [];

if (typeName _mrk == "STRING") then {
	_wpPos = getMarkerPos _mrk;
} else {
	_wpPos = _mrk;
};

if (typeName _infGroups == "ARRAY") then {
	_infGroup1 = _infGroups select 0;
	_infGroup2 = _infGroups select 1;
};

_wp400 = _vehGroup addWaypoint [_dest, 0];
_wp400 setWaypointBehaviour "CARELESS";
_wp400 setWaypointSpeed "FULL";
_wp400 setWaypointType "TR UNLOAD";
_wp400 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; [vehicle this] call smokeCoverAuto"];
_wp401 = _infGroup1 addWaypoint [_dest, 0];
_wp401 setWaypointType "GETOUT";
_wp401 synchronizeWaypoint [_wp400];
if (typeName _infGroups == "ARRAY") then {
	_wp501 = _infGroup2 addWaypoint [_dest, 0];
	_wp501 setWaypointType "GETOUT";
	_wp501 synchronizeWaypoint [_wp400];
};

_wp402 = _infGroup1 addWaypoint [_wpPos, 0];
_wp402 setWaypointType "SAD";
_wp402 setWaypointBehaviour "AWARE";
_infGroup1 setCombatMode "RED";

_wp502 = "";
if (typeName _infGroups == "ARRAY") then {
	_wp502 = _infGroup2 addWaypoint [_wpPos, 0];
	_wp502 setWaypointType "SAD";
	_wp502 setWaypointBehaviour "AWARE";
	_infGroup2 setCombatMode "RED";
};

waitUntil {sleep 5; ((units _infGroup1 select 0) distance _dest < 50) || ({alive _x} count units _vehGroup == 0)};

_infGroup1 setCurrentWaypoint _wp402;
[_vehGroup, _origin] spawn AS_fnc_QRF_RTB;
if (typeName _infGroups == "ARRAY") then {
	_infGroup2 setCurrentWaypoint _wp502;
};

sleep _duration;

[_infGroup1, _origin] spawn AS_fnc_QRF_RTB;
if (typeName _infGroups == "ARRAY") then {
	[_infGroup2, _origin] spawn AS_fnc_QRF_RTB;
};