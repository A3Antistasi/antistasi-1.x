params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration"];

private _infGroup1 = _infGroups;
private _infGroup2 = "";

if (typeName _mrk == "STRING") then {
	_mrk = getMarkerPos _mrk;
};

if (typeName _infGroups == "ARRAY") then {
	_infGroup1 = _infGroups select 0;
	_infGroup2 = _infGroups select 1;
	diag_log format ["QRF - fast rope // two inf groups: %1; %2", _infGroup1, _infGroup2];
};

_wp600 = _vehGroup addWaypoint [_dest, 10];
_wp600 setWaypointBehaviour "CARELESS";
_wp600 setWaypointSpeed "FULL";

private _veh = vehicle (units _infGroup1 select 0);

waitUntil {sleep 1; ((not alive _veh) || (speed _veh < 20)) && (_veh distance _dest < 300)};

_infGroup1 call SHK_Fastrope_fnc_AIs;
if (typeName _infGroups == "ARRAY") then {
	sleep 2;
	(_infGroups select 1) call SHK_Fastrope_fnc_AIs;
};

_wp601 = _infGroup1 addWaypoint [_mrk, 0];
_wp601 setWaypointType "SAD";
_wp601 setWaypointBehaviour "AWARE";

if (typeName _infGroups == "ARRAY") then {
	_wp602 = _infGroup2 addWaypoint [_mrk, 0];
	_wp602 setWaypointType "SAD";
	_wp602 setWaypointBehaviour "AWARE";
};

[_vehGroup, _origin] spawn AS_fnc_QRF_RTB;

sleep _duration;

[_infGroup1, _origin] spawn AS_fnc_QRF_RTB;
if (typeName _infGroups == "ARRAY") then {
	[_infGroup2, _origin] spawn AS_fnc_QRF_RTB;
};