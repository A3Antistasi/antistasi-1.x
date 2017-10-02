params ["_marker"];
private _mrkD = format ["Dum%1",_marker];

if (markerColor _mrkD != guer_marker_colour) then {_mrkD setMarkerColor guer_marker_colour};

call {
	if (_marker in puestos) exitWith {
		_mrkD setMarkerText format ["%2 Outpost: %1", count (garrison getVariable _marker), A3_Str_PLAYER];
	};
	if (_marker in bases) exitWith {
		_mrkD setMarkerText format ["%2 Base: %1", count (garrison getVariable _marker), A3_Str_BLUE];
		_mrkD setMarkerType guer_marker_type;
	};
	if (_marker in power) exitWith {
		_mrkD setMarkerText format ["Power Plant: %1", count (garrison getVariable _marker)];
	};
	if (_marker in recursos) exitWith {
		_mrkD setMarkerText format ["Resource: %1", count (garrison getVariable _marker)];
	};
	if (_marker in aeropuertos) exitWith {
		_mrkD setMarkerText format ["%2 Airport: %1", count (garrison getVariable _marker), A3_Str_BLUE];
		_mrkD setMarkerType guer_marker_type;
	};
	if (_marker in fabricas) exitWith {
		_mrkD setMarkerText format ["Factory: %1", count (garrison getVariable _marker)];
	};
	if (_marker in puertos) exitWith {
		_mrkD setMarkerText format ["Sea Port: %1", count (garrison getVariable _marker)];
	};
};