params ["_marker"];
private ["_position", "_contact", "_towerMarker"];

_contact = false;
_position = _this select 0;
if (typeName _marker == typeName "") then {_position = getMarkerPos _marker};

if (count antenas > 0) then {
	{
		if ((alive _x) and (_position distance _x < 3500)) then {
			_towerMarker = [markers,_x] call BIS_fnc_nearestPosition;
			if !(_towerMarker in mrkFIA) then {_contact = true};
		};
	} forEach antenas;
};

_contact