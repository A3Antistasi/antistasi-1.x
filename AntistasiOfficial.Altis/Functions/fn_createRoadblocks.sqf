if !(isServer) exitWith {};

params ["_marker"];
private ["_position","_roads","_road","_posroad","_roadsCon","_numberOfRBs", "_nearestRB", "_name", "_mrk"];

_position = getMarkerPos _marker;
_numberOfRBs = 0;

{if (getMarkerPos _x distance _position < 1000) then {_numberOfRBs = _numberOfRBs + 1}} forEach controles;

if (_numberOfRBs > 3) exitWith {};

_roads = _position nearRoads 500;

_roads = _roads call BIS_Fnc_arrayShuffle;
{
    _road = _x;
    _posroad = getPos _road;
    if (_numberOfRBs > 4) exitWith {};

    if (_posroad distance _position > 400) then {
        _roadsCon = roadsConnectedto _road;
        if (count _roadsCon > 0) then {
            _nearestRB = [controles,_posroad] call BIS_fnc_nearestPosition;
            if (getMarkerPos _nearestRB distance _posroad > 1000) then {
                _name = format ["control_%1", count controles];
                _mrk = createmarker [format ["%1", _name], _posroad];
                _mrk setMarkerSize [30,30];
                _mrk setMarkerShape "RECTANGLE";
                _mrk setMarkerBrush "SOLID";
                _mrk setMarkerColor IND_marker_colour;
                _mrk setMarkerText _name;
                if (not debug) then {_mrk setMarkerAlpha 0};
                controles pushBackUnique _name;
                markers pushBackUnique _name;
                spawner setVariable [_name,false,true];
                _numberOfRBs = _numberOfRBs + 1;
            };
        };
    };
} forEach _roads;