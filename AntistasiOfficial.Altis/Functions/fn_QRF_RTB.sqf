params ["_vehGroup", "_dest"];

if !(typeName _vehGroup == "GROUP") exitWith {"Error in QRF_RTB: not a group"};

{_x disableAI "AUTOCOMBAT"} forEach units _vehGroup;

while { !({alive _x} count units _vehGroup == 0) && !({_x distance2D _dest > 200} count units _vehGroup == 0)} do
{
	{_x disableAI "AUTOCOMBAT"} forEach units _vehGroup;

	_wp700 = _vehGroup addWaypoint [_dest, 0];
	_wp700 setWaypointSpeed "FULL";
	_wp700 setWaypointBehaviour "CARELESS";
	_wp700 setWaypointCombatMode "GREEN";

	_vehGroup setCurrentWaypoint _wp700;
	sleep 5;
};

waitUntil {sleep 1; ({alive _x} count units _vehGroup == 0) || ({_x distance2D _dest > 200} count units _vehGroup == 0)};
{deleteVehicle _x} forEach units _vehGroup + [vehicle leader _vehGroup]; deleteGroup _vehGroup;