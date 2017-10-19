params ["_unit", "_corpse"];

diag_log format ["corpse: %1; type: %2", _corpse, typeOf _corpse];

if (_corpse isKindOf "Man") then {
	if !(vest _corpse == "") then {
		_unit action ["rearm",_corpse];
		sleep 3;
		_unit addVest (vest _corpse);
	};

	if !(backpack _corpse == "") then {
		_unit action ["rearm",_corpse];
		sleep 3;
		_unit addBackpack (backpack _corpse);
	};

	if !(headgear _corpse == "") then {
		_unit action ["rearm",_corpse];
		sleep 3;
		_unit addHeadgear (headgear _corpse);
	};

	if !(hmd _corpse == "") then {
		_unit action ["rearm",_corpse];
		sleep 3;
		_unit addItem (hmd _corpse);
	};

	if !(primaryWeapon _corpse == "") then {
		_unit action ["rearm",_corpse];
		sleep 3;
		[_unit, primaryWeapon _corpse, 0] call BIS_fnc_addWeapon
	};

	if !(secondaryWeapon _corpse == "") then {
		[_unit, secondaryWeapon _corpse, 0] call BIS_fnc_addWeapon
	};

	if (count (magazines _corpse) > 0) then {
		{_unit addMagazine [_x,1]} forEach (magazines _corpse);
	};

	{_corpse removeMagazine _x} forEach magazines _corpse;
	removeAllWeapons _corpse;
	removeVest _corpse;
	removeHeadgear _corpse;
	removeBackpack _corpse;
};

if (typeOf _corpse == "Box_IND_Wps_F") then {
	_weapons = weaponCargo _corpse;
	_magazines = magazineCargo _corpse;
	_items = itemCargo _corpse;
	_backpacks = backpackCargo _corpse;

	diag_log "got a box";

	if (count _backpacks > 0) then {
		unit action ["rearm",_corpse];
		sleep 3;
		_unit addBackpack (selectRandom _backpacks);
	};

	if (count _items > 0) then {
		{
			if (_x isKindOf "Vest_Camo_Base") then {
				_unit action ["rearm",_corpse];
				sleep 3;
				_unit addVest _x;
			};
			if (_x isKindOf "H_HelmetB") then {
				_unit action ["rearm",_corpse];
				sleep 3;
				_unit addHeadgear _x;
			};
			if (_x isKindOf "Binocular") then {
				_unit action ["rearm",_corpse];
				sleep 3;
				_unit addItem _x;
			};
		} forEach _items;
	};

	if (count _weapons > 0) then {
		{[_unit, _x, 0] call BIS_fnc_addWeapon} forEach _weapons;
	};

	if (count _magazines > 0) then {
		{_unit addMagazine [_x,1]} forEach (_magazines);
	};

	clearWeaponCargoGlobal _corpse;
	clearMagazineCargoGlobal _corpse;
	clearItemCargoGlobal _corpse;
	clearBackpackCargoGlobal _corpse;
};

_unit setVariable ["AS_strippingCorpse", nil, true];