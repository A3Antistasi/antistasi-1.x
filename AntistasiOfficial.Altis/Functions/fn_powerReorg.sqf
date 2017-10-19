params ["_marker"];
private ["_city","_position","_power","_powered", "_factRes", "_location"];

{
	_city = _x;
	_position = getMarkerPos _x;
	_power = [power,_position] call BIS_fnc_nearestPosition;
	_powered = true;

	if (_power == _marker) then {
		if (_marker in destroyedCities) then {
			_powered = false;
		} else {
			if (_marker in mrkFIA) then {
				if (_city in mrkFIA) then {
					[5,0] remoteExec ["prestige",2];
				} else {
					[-5,0] remoteExec ["prestige",2];
					_powered = false;
				};
			} else {
				if (_city in mrkFIA) then {
					[5,0] remoteExec ["prestige",2];
					_powered = false;
				};
			};
		};

		[_city,_powered] spawn AS_fnc_adjustLamps;
	};
} forEach ciudades;

_factRes = fabricas + recursos;
{
	_location = _x;
	_position = getMarkerPos _x;
	_power = [power,_position] call BIS_fnc_nearestPosition;
	_powered = true;

	if (_power == _marker) then {
		if (_marker in destroyedCities) then {
			_powered = false;
		} else {
			if (_marker in mrkFIA) then {
				if (_location in mrkAAF) then {
					_powered = false;
				};
			} else {
				if (_location in mrkFIA) then {
					_powered = false;
				};
			};
		};

		[_location,_powered] spawn AS_fnc_adjustLamps;
	};
} forEach _factRes;