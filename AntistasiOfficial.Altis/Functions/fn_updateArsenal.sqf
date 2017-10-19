if !(isServer) exitWith {};
private ["_weapons","_baseWeapons","_addedWeapons","_lockedWeapon","_weaponCargo","_precio","_weapon","_priceAdd","_updated","_magazines","_addedMagazines","_magazine","_magazineCargo","_items","_addedItems","_item","_cuenta","_itemCargo","_backpacks","_baseBackpacks","_addedBackpacks","_lockedBackpack","_backpackCargo","_mochi","_backpack","_weaponsItems","_wpnItem", "_itemReq","_tempList","_magList","_delList","_baseWeapon"];

_updated = "";

_weapons = weaponCargo caja;
_backpacks = backpackCargo caja;
_magazines = magazineCargo caja;
_items = itemCargo caja;

// Check magazines
_tempList = _magazines arrayIntersect _magazines;
_delList = [];
_addedMagazines = [];
{
	_mag = _x;
	if !(_mag in unlockedMagazines) then {
		if ({_x == _mag} count _magazines >= ["magazines"] call AS_fnc_getUnlockRequirement) then {
			_addedMagazines pushBackUnique _mag;
			unlockedMagazines pushBackUnique _mag;
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _mag >> "displayName")]
		};
	} else {
		_delList pushBackUnique _mag;
	};
} forEach _tempList;

_magazines = _magazines - _delList - _addedMagazines;

// Check weapons, base models
_baseWeapons = [];
{
	_baseWeapons pushBack ([_x] call BIS_fnc_baseWeapon);
} forEach _weapons;

_tempList = _baseWeapons arrayIntersect _baseWeapons;
_delList = [];
_addedWeapons = [];
{
	_lockedWeapon = _x;
	if !(_lockedWeapon in unlockedWeapons) then {
		if ({_x == _lockedWeapon} count _baseWeapons >= ["weapons"] call AS_fnc_getUnlockRequirement) then {
			_blockUnlock = true;

			_magList = server getVariable [format ["%1_mags", _lockedWeapon], []];
			if (count _magList > 0) then {
				{
					if (_x in unlockedMagazines) exitWith {_blockUnlock = false};
				} forEach _magList;

				if !(_blockUnlock) then {
					_addedWeapons pushBackUnique _lockedWeapon;
					unlockedWeapons pushBackUnique _lockedWeapon;
					_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _lockedWeapon >> "displayName")];
				};
			};
		};
	} else {
		_delList pushBackUnique _lockedWeapon;
	};
} forEach _tempList;

_weapons = _weapons - _delList - _addedWeapons;


if (!("Rangefinder" in unlockedWeapons) OR !(indRF in unlockedWeapons)) then {
	if ({(_x == "Rangefinder") OR (_x == indRF)} count weaponCargo caja >= ["weapons"] call AS_fnc_getUnlockRequirement) then {
		_addedWeapons pushBackUnique "Rangefinder";
		unlockedWeapons pushBackUnique "Rangefinder";
		_addedWeapons pushBackUnique indRF;
		unlockedWeapons pushBackUnique indRF;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Rangefinder" >> "displayName")];
	};
};


if (count _addedMagazines > 0) then {
	if ((atMine in _addedMagazines) OR (apMine in _addedMagazines)) then {
		if (activeBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
	};

	// XLA fixed arsenal
	if (activeXLA) then {
		[caja,_addedMagazines,true,false] call XLA_fnc_addVirtualMagazineCargo;
	} else {
		[caja,_addedMagazines,true,false] call BIS_fnc_addVirtualMagazineCargo;
	};
	publicVariable "unlockedMagazines";
};

_magazineCargo = [];
for "_i" from 0 to (count _magazines) - 1 do {
	_magazine = _magazines select _i;
	if !(_magazine in unlockedMagazines) then {
		_magazineCargo pushBack _magazine;
	};
};

if (count _addedWeapons > 0) then {
	lockedWeapons = lockedWeapons - _addedWeapons;
	if (activeBE) then {["unl_wpn", count _addedWeapons] remoteExec ["fnc_BE_XP", 2]};

	// XLA fixed arsenal
	if (activeXLA) then {
		[caja,_addedWeapons,true,false] call XLA_fnc_addVirtualWeaponCargo;
	} else {
		[caja,_addedWeapons,true,false] call BIS_fnc_addVirtualWeaponCargo;
	};
	publicVariable "unlockedWeapons";
	[_addedWeapons] spawn AS_fnc_weaponsCheck;
};

_weaponCargo = [];
_weaponsItems = weaponsItems caja;
for "_i" from 0 to (count _weapons) - 1 do {
	_weapon = _weapons select _i;
	_baseWeapon = _baseWeapons select _i;
	if (not(_baseWeapon in unlockedWeapons)) then {
		_weaponCargo pushBack _weapon;
	} else {
		if (_weapon != _baseWeapon) then {
			if (count _weaponsItems > 0) then {
				_wpnItem = _weaponsItems select _i;
				if ((_wpnItem select 0) == _weapon) then {
					{
						if (typeName _x != typeName []) then {_items pushBack _x};
					} forEach (_wpnItem - [_weapon]);
				};
			};
		};
	};
};

_baseBackpacks = [];
{
	_backpack = _x call BIS_fnc_basicBackpack;
	_baseBackpacks pushBack _backpack;
} forEach _backpacks;

_addedBackpacks = [];
	{
	_lockedBackpack = _x;
	if ({_x == _lockedBackpack} count _baseBackpacks >= ["backpacks"] call AS_fnc_getUnlockRequirement) then {
		_addedBackpacks pushBackUnique _lockedBackpack;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgVehicles" >> _lockedBackpack >> "displayName")];
	};
} forEach genBackpacks;

if (count _addedBackpacks > 0) then {
	genBackpacks = genBackpacks - _addedBackpacks;

	// XLA fixed arsenal
	if (activeXLA) then {
		[caja,_addedBackpacks,true,false] call XLA_fnc_addVirtualBackpackCargo;
	} else {
		[caja,_addedBackpacks,true,false] call BIS_fnc_addVirtualBackpackCargo;
	};
	unlockedBackpacks = unlockedBackpacks + _addedBackpacks;
	publicVariable "unlockedBackpacks";
};

_backpackCargo = [];
for "_i" from 0 to (count _backpacks) - 1 do {
	_mochi = _backpacks select _i;
	_backpack = _baseBackpacks select _i;
	if (not(_backpack in unlockedBackpacks)) then {
		_backpackCargo pushBack _mochi;
	};
};

_tempList = _items arrayIntersect _items;
_delList = [];
_addedItems = [];
{
	_item = _x;
	if !(_item in unlockedItems) then {
		_itemReq = ["items"] call AS_fnc_getUnlockRequirement;
		if !(_item in genItems) then {_itemReq = _itemReq + 10};
		if ((_item in genVests) OR (_item in genOptics) OR (_item in genHelmets)) then {_itemReq = ["vests"] call AS_fnc_getUnlockRequirement;};
		if ({_x == _item} count _items >= _itemReq) then {
			_addedItems pushBackUnique _item;
			unlockedItems pushBackUnique _item;
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
			if (_item in genOptics) then {unlockedOptics pushBackUnique _item; publicVariable "unlockedOptics"};
			if (_item in genVests) then {
				if (activeBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
			};
		};
	} else {
		_delList pushBack _item;
	};
} forEach _tempList - ["NVGoggles","Laserdesignator"];

_items = _items - _delList - _addedItems;


if !("NVGoggles" in unlockedItems) then {
	if ({(_x == "NVGoggles") or (_x == "NVGoggles_OPFOR") or (_x == "NVGoggles_INDEP") or (_x == indNVG)} count itemCargo caja >= ["items"] call AS_fnc_getUnlockRequirement) then {
		_addedItems = _addedItems + ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",indNVG];
		unlockedItems = unlockedItems + ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP",indNVG];
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "NVGoggles" >> "displayName")];
		if (activeBE) then {["unl_wpn"] remoteExec ["fnc_BE_XP", 2]};
	};
};

if !("Laserdesignator" in unlockedItems) then {
	if ({(_x == "Laserdesignator") or (_x == "Laserdesignator_02") or (_x == "Laserdesignator_03")} count itemCargo caja >= ["items"] call AS_fnc_getUnlockRequirement) then {
		_addedItems pushBack "Laserdesignator";
		unlockedItems pushBackUnique "Laserdesignator";
		unlockedMagazines pushBackUnique "Laserbatteries";
		publicVariable "unlockedMagazines";
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Laserdesignator" >> "displayName")];
	};
};

if ((activeACE) && ("ItemGPS" in unlockedItems)) then {
	unlockedItems pushBackUnique "ACE_DAGR";
};

if (count _addedItems >0) then {
	// XLA fixed arsenal
	if (activeXLA) then {
		[caja,_addedItems,true,false] call XLA_fnc_addVirtualItemCargo;
	} else {
		[caja,_addedItems,true,false] call BIS_fnc_addVirtualItemCargo;
	};
	publicVariable "unlockedItems";
};

_itemCargo = [];

for "_i" from 0 to (count _items) - 1 do {
	_item = _items select _i;
	if (!(_item in unlockedItems) && !(toLower _item find "tf_anprc" >= 0)) then {
		_itemCargo pushBack _item;
	};
};

if (count _weapons != count _weaponCargo) then {
	clearWeaponCargoGlobal caja;
	{caja addWeaponCargoGlobal [_x,1]} forEach _weaponCargo;
	unlockedRifles = unlockedweapons -  gear_sidearms -  gear_missileLaunchers - gear_rocketLaunchers - gear_sniperRifles - gear_machineGuns; publicVariable "unlockedRifles";
};

if (count _backpacks != count _backpackCargo) then {
	clearBackpackCargoGlobal caja;
	{caja addBackpackCargoGlobal [_x,1]} forEach _backpackCargo;
};

if (count _magazines != count _magazineCargo) then {
	clearMagazineCargoGlobal caja;
	{caja addMagazineCargoGlobal [_x,1]} forEach _magazineCargo;
};

if (count _items != count _itemCargo) then {
	clearItemCargoGlobal caja;
	{caja addItemCargoGlobal [_x,1]} forEach _itemCargo;
};

unlockedRifles = unlockedweapons - gear_sidearms - gear_missileLaunchers - gear_rocketLaunchers - gear_sniperRifles - gear_machineGuns; publicVariable "unlockedRifles";
publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";

_updated