params ["_marker"];
private ["_result","_power"];

_result = false;
_power = [power, getMarkerPos _marker] call BIS_fnc_nearestPosition;

if (_power in destroyedCities) then {
	_result = false;
} else {
	if ((_marker in mrkAAF) and (_power in mrkAAF)) then {
		_result = true
	} else {
		if ((_marker in mrkFIA) and (_power in mrkFIA)) then {
			_result = true
		};
	};
};

_result