if (!isServer) exitWith{};

params ["_delay"];
private _friendlyBases = count (bases - mrkAAF);

diag_log format ["Attack Timer -- number of bases: %1", _friendlyBases];

call {
	if (_friendlyBases > 3) exitWith {
		_delay = _delay * 0.3;
	};
	if ((_friendlyBases == 3) && (skillAAF < 10)) exitWith {
		_delay = _delay * 0.5;
	};
	if (_friendlyBases >= 2) exitWith {
		_delay = _delay * 0.75;
	};
	if (_friendlyBases == 1) exitWith {
		_delay = _delay * 0.9;
	};
};

diag_log format ["Attack Timer -- number: %1", _delay];

cuentaCA = cuentaCA + round ((_delay/2) + random _delay);
if (cuentaCA < 0) then {cuentaCA = 300};
publicVariable "cuentaCA";

diag_log format ["Attack Timer -- timer changed: %1", cuentaCA];