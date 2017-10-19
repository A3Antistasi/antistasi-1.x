if (!isServer and hasInterface) exitWith {};

params ["_crate", "_AAFcrate", "_FIAcrate", "_weaponList", "_magList", "_itemList", "_opticsList", "_mineList", "_typeInt", "_classInt", "_item", "_mags", "_rlist"];

private ["_cosa","_num","_magazines"];

[_crate] call emptyCrate;

_AAFcrate = "I_supplyCrate_F";
_FIAcrate = "IG_supplyCrate_F";
_weaponList = genWeapons - unlockedWeapons;
_magList = genAmmo - unlockedMagazines;
_itemList = genItems - unlockedItems;
_opticsList = genOptics - unlockedOptics;
_launcherList = genLaunchers - unlockedWeapons;
_mineList = genMines - unlockedMagazines;

_extWList = vanillaWeapons;
_extMList = vanillaMagazines;
_extIList = vanillaAccessories;
if (activeAFRF) then {
	_extWList = rhsWeaponsAFRF;
	_extMList = rhsMagazines;
	_extIList = rhsAccessoriesAFRF;
};

_fnc_checkList = {
	params ["_cat"];
	private ["_list", "_extList"];

	call {
		if (_cat == "weapon") exitWith {
			_list = _weaponList;
			_extList = _extWList;
		};
		if (_cat == "magazine") exitWith {
			_list = _magList;
			_extList = _extMList;
		};
		if (_cat == "item") exitWith {
			_list = _itemList;
			_extList = _extIList;
		};
	};

	if (count _list == 0) then {
		_list = [];
		for "_i" from 0 to 9 do {
			_list pushBackUnique (selectRandom _extList);
		};
	};
	_list
};

_fnc_gear = {
	params ["_cat", ["_typeRan", 4], ["_classRan", 4], ["_magMult", 3]];

	if (_cat == "weapon") exitWith {
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_weaponList = [_cat] call _fnc_checkList;

			_item = selectRandom _weaponList;
			_weaponList = _weaponList - [_item];
			_crate addWeaponCargoGlobal [_item, _classInt];

			if (count (getArray (configFile / "CfgWeapons" / _item / "magazines")) > 0) then {
				_mags = getArray (configFile / "CfgWeapons" / _item / "magazines") select 0;
				_crate addMagazineCargoGlobal [_mags, _classInt * _magMult];
			};
		};
	};

	if (_cat == "magazine") exitWith {
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_magList = [_cat] call _fnc_checkList;

			_item = selectRandom _magList;
			_crate addMagazineCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "item") exitWith {
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_itemList = [_cat] call _fnc_checkList;

			_item = selectRandom _itemList;
			_crate addItemCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "optic") exitWith {
		if (count _opticsList == 0) exitWith {};
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_item = selectRandom _opticsList;
			_crate addItemCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "launcher") exitWith {
		if (count _launcherList == 0) exitWith {};
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_item = selectRandom _launcherList;
			_crate addWeaponCargoGlobal [_item, _classInt];
			_mags = getArray (configFile / "CfgWeapons" / _item / "magazines") select 0;
			_crate addMagazineCargoGlobal [_mags, _classInt * _magMult];
		};
	};

	if (_cat == "mine") exitWith {
		if (count _mineList == 0) exitWith {};
		_typeInt = 1 + (floor random _typeRan);

		for "_i" from 0 to _typeInt do {
			_classInt = 1 + (floor random _classRan);
			_item = selectRandom _mineList;
			_crate addMagazineCargoGlobal [_item, _classInt];
		};
	};
};


call {
	if ((typeOf _crate == _AAFcrate) or (typeOf _crate == _FIAcrate)) exitWith {
		["weapon", 4, 4, 3] call _fnc_gear;
		["magazine", 5, 10] call _fnc_gear;
		["item", 5, 5] call _fnc_gear;
		["mine", 3, 5] call _fnc_gear;
		["optic", 2, 2] call _fnc_gear;
		["launcher", 2, 2, 3] call _fnc_gear;
	};

	if (typeOf _crate == vehAmmo) exitWith {
		["weapon", 4, 6, 3] call _fnc_gear;
		["magazine", 5, 20] call _fnc_gear;
		["item", 5, 5] call _fnc_gear;
		["mine", 3, 10] call _fnc_gear;
		["optic", 2, 3] call _fnc_gear;
		["launcher", 2, 2, 3] call _fnc_gear;
	};

	if (typeOf _crate == opCrate) exitWith {
		_item = genAALaunchers select 0;
		_crate addWeaponCargoGlobal [_item, 5];
		_crate addMagazineCargoGlobal [getArray (configFile / "CfgWeapons" / _item / "magazines") select 0, 10];
	};

	if (typeOf _crate == campCrate) exitWith {
		for "_i" from 0 to 2 do {
			_item = selectRandom unlockedWeapons;
			_crate addWeaponCargoGlobal [_item, 5];
			_crate addMagazineCargoGlobal [getArray (configFile / "CfgWeapons" / _item / "magazines") select 0, 30];
		};

		_rlist = genATLaunchers arrayIntersect unlockedWeapons;
		if (count _rlist > 0) then {
			_item = selectRandom (_rlist);
			_crate addWeaponCargoGlobal [_item, 5];
			_crate addMagazineCargoGlobal [getArray (configFile / "CfgWeapons" / _item / "magazines") select 0, 15];
		};

		if (indNVG in unlockedItems) then {
			_crate addItemCargoGlobal [indNVG, 10];
		};

		if (indNVG in unlockedItems) then {
			_crate addItemCargoGlobal [indNVG, 10];
		};

		_crate addItemCargoGlobal ["FirstAidKit", 10];
		_crate addItemCargoGlobal ["ToolKit", 1];

		if ("ItemRadio" in unlockedItems) then {
			_crate addItemCargoGlobal ["ItemRadio", 5];
		};

		if (activeTFAR) then {
			//_crate addBackpackCargoGlobal ["tf_rt1523g_big_bwmod",1];
			_crate addBackpackCargoGlobal ["tf_anprc155_coyote",1];
		};
	};
};

if (activeTFAR) then {
	if (typeOf _crate == _FIAcrate) then {
		_crate addBackpackCargoGlobal [lrRadio,2];
	} else {
		if (4 < random 5) then {
			_crate addBackpackCargoGlobal [lrRadio,1];
		};
	};
};

_crate addBackpackCargoGlobal ["B_Carryall_oli", 1];

//Add the action to load the crate with Jeroen's loading script. Sparker.
if(!(_crate isEqualTo caja)) then
{
	_crate call jn_fnc_logistics_addAction;
};