_c = _this select 0;
_t = _this select 1;
_m = _this select 2;
if (count _this > 2) then {_p = _this select 3};

_f = 0;
_pos = getPos expCrate;

_f = server getVariable "resourcesFIA";

if (_f < _m) exitWith {
	_l1 = ["Devin", "Get lost ya cheap wanker!"];
    [[_l1],"DIRECT",0.15] execVM "createConv.sqf";
};

_weapons = lockedWeapons;
_accessories = gear_allAccessories;
_standardWeapons = vanillaWeapons;
_standardAccessories = vanillaAccessories;

if (activeACE) then {
	_standardWeapons = vanillaWeapons + aceWeapons;
	_standardAccessories = vanillaAccessories + aceAccessories;
};

_noWeaponMods = true;
if !(count (lockedWeapons - _standardWeapons) == 0) then {
	_noWeaponMods = false;
	_weapons = lockedWeapons - _standardWeapons;
	_accessories = gear_allAccessories - _standardAccessories;
};

//"  if ("rhs_group_rus_vdv_infantry_section_AT" in infAT) then {
//	if !(count (_weapons - rhsWeaponsAFRF - rhsWeaponsUSAF - rhsWeaponsAFRF_extra) == 0) then {
//		_weapons = _weapons - rhsWeaponsAFRF - rhsWeaponsUSAF - rhsWeaponsAFRF_extra;
//		_accessories = _accessories - rhsAccessoriesAFRF - rhsAccessoriesUSAF;
//	};
//}; " 
// fireman 16/08 This ruin the rhs/extra mod _weapons 
// Untill no negative results this is a fix for the irish men

_noGear = false;
switch (_t) do {
	case "ASRifles": {
		_aRifles = _weapons arrayIntersect gear_assaultRifles;
		if (count _aRifles == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _aRifles call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 4];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _aRifles call BIS_Fnc_selectRandom;
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 6];
			};
		};
	};

	case "Machineguns": {
		_mGuns = _weapons arrayIntersect gear_machineGuns;
		if (count _mGuns == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _mGuns call BIS_Fnc_selectRandom;
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, 3];
				expCrate addMagazineCargoGlobal [selectRandom _magazines, 2];
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _mGuns call BIS_Fnc_selectRandom;
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, 4];
				expCrate addMagazineCargoGlobal [selectRandom _magazines, 3];
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
			};
		};
	};

	case "Sniper Rifles": {
		_sRifles = _weapons arrayIntersect gear_sniperRifles;
		if (count _sRifles == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _sRifles call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 4];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _sRifles call BIS_Fnc_selectRandom;
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 6];
			};
		};
	};

	case "Launchers": {
		_combined = gear_missileLaunchers + gear_rocketLaunchers;
		_launchers = _weapons arrayIntersect _combined;
		if (count _launchers == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _launchers call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 4];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _launchers call BIS_Fnc_selectRandom;
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 6];
			};
		};
	};

	case "Pistols": {
		_pistols = _weapons arrayIntersect gear_sidearms;
		if (count _pistols == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _pistols call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 4];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _pistols call BIS_Fnc_selectRandom;
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 6];
			};
		};
	};

	case "Random": {
		if (count _weapons == 0) exitWith {_noGear = true};
		if (_m == 1000) exitWith {
			for "_i" from 1 to 3 do {
				_cosa = _weapons call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 4];
			};
		};
		if (_m == 2500) exitWith {
			for "_i" from 1 to 8 do {
				_cosa = _weapons call BIS_Fnc_selectRandom;
				_num = 2 + (floor random 4);
				expCrate addItemCargoGlobal [_cosa, _num];
				_magazines = getArray (configFile / "CfgWeapons" / _cosa / "magazines");
				expCrate addMagazineCargoGlobal [_magazines select 0, _num * 6];
			};
		};
	};
	case "aCache": {
		if (count _accessories == 0) exitWith {_noGear = true};
		if (_m == 500) exitWith {
			for "_i" from 1 to 2 do {
				_cosa = _accessories call BIS_Fnc_selectRandom;
				_num = 1;
				expCrate addItemCargoGlobal [_cosa, _num];
			};
		};
		if (_m == 5000) exitWith {
			for "_i" from 1 to 10 do {
				_cosa = _accessories call BIS_Fnc_selectRandom;
				_num = 1 + (floor random 2);
				expCrate addItemCargoGlobal [_cosa, _num];
			};
		};
	};
	case "resupply": {
		if (_m == 300) exitWith {
			_pWeapon = primaryWeapon _p;
			_pWeaponMagazines = getArray (configFile / "CfgWeapons" / _pWeapon / "magazines");
			_pWeaponAmmo = _pWeaponMagazines select 0;
			_num = 8;
			expCrate addItemCargoGlobal [_pWeaponAmmo, _num];
		};
	};
	case "expLight": {
		if (_m == 300) exitWith {
			expCrate addMagazineCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag", 1];
			expCrate addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 3];

		};
		if (_m == 800) exitWith {
			expCrate addMagazineCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag", 3];
			expCrate addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 8];
			expCrate addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 8];
		};
	};
	case "expHeavy": {
		if (_m == 300) exitWith {
			expCrate addMagazineCargoGlobal [apMine, 5];
			expCrate addMagazineCargoGlobal [atMine, 2];
			expCrate addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 2];
		};
		if (_m == 800) exitWith {
			expCrate addMagazineCargoGlobal [apMine, 8];
			expCrate addMagazineCargoGlobal [atMine, 4];
			expCrate addMagazineCargoGlobal ["SLAMDirectionalMine_Wire_Mag", 4];
			expCrate addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", 1];
			expCrate addMagazineCargoGlobal ["APERSTripMine_Wire_Mag", 3];
		};
	};
};

if (_noGear) exitWith {
	_l3 = ["Devin", "Sorry, lad. Don't have any guns right now. Check back later."];
	[[_l3],"DIRECT",0.15] execVM "createConv.sqf";
};

expCrate addBackpackCargoGlobal ["B_Carryall_oli", 1];

_l2 = ["Devin", "Aye, the market for explosives is boomin'. They be hard to get a hold of, don't ya know."];
if (_m > 1000) then {_l2 = ["Devin", "Yer a fine customer. Give ya an ever better deal next time."]};
[[_l2],"DIRECT",0.15] execVM "createConv.sqf";

[0, (-1* _m)] remoteExec ["resourcesFIA",2];