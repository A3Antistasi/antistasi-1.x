params ["_markerOne", "_markerTwo"];

private _return = false;

if (_markerOne isEqualType "") then {_markerOne = getMarkerPos _markerOne};
if (_markerTwo isEqualType "") then {_markerTwo = getMarkerPos _markerTwo};

call {
	if (_markerOne distance getMarkerPos "isla" <= 5500) exitWith {
		if (_markerTwo distance getMarkerPos "isla" <= 5500) then {_return = true};
	};
	if (_markerOne distance getMarkerPos "isla_1" <= 2000) exitWith {
		if (_markerTwo distance getMarkerPos "isla_1" <= 2000) then {_return = true};
	};
	if (_markerOne distance getMarkerPos "isla_2" <= 2000) exitWith {
		if (_markerTwo distance getMarkerPos "isla_2" <= 2000) then {_return = true};
	};
	if (_markerOne distance getMarkerPos "isla_3" <= 3000) exitWith {
		if (_markerTwo distance getMarkerPos "isla_3" <= 3000) then {_return = true};
	};
	if (_markerOne distance getMarkerPos "isla_4" <= 2500) exitWith {
		if (_markerTwo distance getMarkerPos "isla_4" <= 2500) then {_return = true};
	};
};

_return