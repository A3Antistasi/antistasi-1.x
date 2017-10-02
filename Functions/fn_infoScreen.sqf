params ["_type"];

private _pI = [];
private _p2 = [];
private _p3 = [];

if (_type == "status") then {

	private _p1 = ["Number of vehicles in garage: %1", count vehInGarage];
	_pI pushBackUnique (format _p1);

	if (count vehInGarage > 0) then {
		private _vehicleTypes = [];
		{
			_vehicleTypes pushBackUnique _x;
		} forEach vehInGarage;
		_p2 = ["List of vehicles \n"];
		_p2v = [];
		for "_i" from 0 to (count _vehicleTypes - 1) do {
			_p2 pushBack ("%" + str ((2*(_i+1))-1) + " x %" + str (2*(_i+1)));
			if (_i < (count _vehicleTypes - 1)) then {_p2 pushBack ", "};
			_p2v = _p2v + [getText (configFile >> "CfgVehicles" >> _vehicleTypes select _i >> "displayName"), ({_x == _vehicleTypes select _i} count vehInGarage)];
		};
		_p2 = _p2 joinString "";
		_p2 = [_p2] + _p2v;
		_pI pushBackUnique (format _p2);
	};

	private _p3 = ["Weapon categories unlocked\nLMG: %1 -- GL: %2 -- Sniper: %3 -- AT: %4 -- AA: %5", !(server getVariable ["genLMGlocked",false]), !(server getVariable ["genGLlocked",false]), !(server getVariable ["genSNPRlocked",false]), !(server getVariable ["genATlocked",false]), !(server getVariable ["genAAlocked",false])];
	_pI pushBackUnique (format _p3);

	private _p4 = ["List of unlocked weapons \n"];
	_p4 = ["List of unlocked weapons\n"];
		_p4v = [];
		for "_i" from 0 to (count unlockedWeapons - 1) do {
			_p4 pushBack ("%" + str (_i + 1));
			if (_i < (count unlockedWeapons - 1)) then {_p4 pushBack ", "};
			_p4v = _p4v + [getText (configFile >> "CfgWeapons" >> unlockedWeapons select _i >> "displayName")];
		};
		_p4 = _p4 joinString "";
		_p4 = [_p4] + _p4v;
	_pI pushBackUnique (format _p4);
};

[petros,_type,_pI] remoteExec ["commsMP",Slowhand];