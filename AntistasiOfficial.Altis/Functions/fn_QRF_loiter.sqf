params ["_vehGroup", "_origin", "_dest", "_radius", "_duration"];

diag_log format ["Vehloiter %1", _vehGroup];
_wp101 = _vehGroup addWaypoint [_dest, 50];
_wp101 setWaypointType "LOITER";
_wp101 setWaypointLoiterType "CIRCLE";
_wp101 setWaypointLoiterRadius _radius;
_wp101 setWaypointSpeed "LIMITED";

if (vehicle ((units _vehGroup) select 0) isKindOf "UAV") then
{
	vehicle ((units _vehGroup) select 0) flyInHeight 300;
};

sleep _duration;
[_vehGroup, _origin] spawn AS_fnc_QRF_RTB;