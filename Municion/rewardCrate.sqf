if (!isServer) exitWith {};

_crate = _this select 0;


if (random 10 < 5) then {
	for [{_i=1},{_i<=(1 + round random 2)},{_i=_i+1}] do {
		_cosa = genMines call BIS_Fnc_selectRandom;
		_num = 1 + (floor random 5);
		if (not(_cosa in unlockedMagazines)) then {_crate addMagazineCargoGlobal [_cosa, _num]};
	};
}
else {
	if (_ran == 1) then {
		for [{_i=1},{_i<=(1 + round random 2)},{_i=_i+1}] do {
			_cosa = genOptics call BIS_Fnc_selectRandom;
			_num = 1 + (floor random 5);
			if (not(_cosa in unlockedOptics)) then {_crate addItemCargoGlobal [_cosa, _num]};
		};
	}
	else {
		for [{_i=1},{_i<=(1 + round random 2)},{_i=_i+1}] do {
			_cosa = genWeapons call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 5);
			if (not(_cosa in unlockedWeapons)) then {
				_crate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				_crate addMagazineCargoGlobal [_magazines select 0, _num * 3];
			};
		};
	};
};