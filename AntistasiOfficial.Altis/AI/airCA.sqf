/*
This script should send a jet to chase the FIA aircraft which is annoying AAF.
0 = blufor aircraft
*/

_FIAaricraft = _this select 0
_targetpos = position (_FIAaricraft);

_airport = [_targetpos] call AS_fnc_findAirportForCA;
_airportpos = getmakerpos [_airport];
_depart = [_airportpos select 0, _airportpos select 1,300];
_jet = [_depart, 0,dogfight, side_green] call bis_fnc_spawnvehicle;
_pilot = driver (_jet select 0);
_pilot reveal _FIAaricraft;
_pilot dotarget _FIAaricraft;

waitUntil {
    !alive (_FIAaricraft);
};

if (!alive _FIAaricraft) then {
    _wp0 = _pilot addWaypoint [_airportpos, 0];
    [_pilot,0] setWaypointBehaviour "CARELESS";
    _wp0 setWaypointSpeed "FULL";
    _wp0 setWaypointStatements ["true", "deletevehicle _this"];
}
