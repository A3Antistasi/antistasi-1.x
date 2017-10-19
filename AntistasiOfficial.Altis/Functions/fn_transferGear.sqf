if (!isServer) exitWith {};

params ["_originContainer","_targetContainer"];
[[],[],[],[],[],[],[],[],[],[]] params ["_backpacks","_weapons","_finalWeapons","_finalWeaponCount","_finalMagazines","_finalMagazineCount","_finalItems","_finalItemCount","_finalBackpacks","_finalBackpackCount"];
private ["_magazineCargo","_weaponsItemsCargo","_itemCargo","_backpackCargo","_containers","_item","_updated"];

_weaponsItemsCargo = weaponsItemsCargo _originContainer;
_magazineCargo = magazineCargo _originContainer;
_itemCargo = itemCargo _originContainer;
_backpackCargo = backpackCargo _originContainer;
_containers = everyContainer _originContainer;

if (count backpackCargo _originContainer > 0) then {
	{
		_backpacks pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _originContainer;
};

if (count _containers > 0) then {
	{
		[weaponsItemsCargo (_x select 1),magazineCargo (_x select 1),itemCargo (_x select 1)] params ["_contWeapItems","_contMags","_contItems"];
		if (count _contWeapItems > 0) then {_weaponsItemsCargo = _weaponsItemsCargo + _contWeapItems};
		if (count _contMags > 0) then {_magazineCargo = _magazineCargo + _contMags};
		if (count _contItems > 0) then {_itemCargo = _itemCargo + _contItems};
	} forEach _containers;
};

if (count _weaponsItemsCargo > 0) then {
	{
		_weapons pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);

		if ((activeAFRF) AND (isNumber (configFile >> "CfgWeapons" >> (_x select 0) >> "rhs_disposable"))) then {
			_magazineCargo pushBack ((getArray (configFile >> "CfgWeapons" >> (_x select 0) >> "magazines")) select 0);
		} else {
			_magazineCargo pushBack ((_x select 4) select 0);
		};

		for "_i" from 1 to (count _x) - 1 do {
			_item = _x select _i;
			if (typeName _item == "STRING") then {
				if (_item != "") then {
					_itemCargo pushBack _item;
				};
			} else {
				if (typeName _item == "ARRAY") then {
					if (count _item > 0) then {
						_item = _item select 0;
						if (!isNil "_item") then {_magazineCargo pushBack _item};
					};
				};
			};
		};
	} forEach _weaponsItemsCargo;
};


{
	_item = _x;
	if (!(_item in _finalWeapons) AND ([!(_item in unlockedWeapons),true] select activeJNA)) then {
		if (_item in blockedWeapons) then {
			_finalWeapons pushBack ([_item] call AS_fnc_weaponReplacement);
		} else {
			_finalWeapons pushBackUnique _item;
		};
		_finalWeaponCount pushBack ({_x == _item} count _weapons);
	};
} forEach _weapons;

if (count _finalWeapons > 0) then {
	for "_i" from 0 to (count _finalWeapons - 1) do {
		_targetContainer addWeaponCargoGlobal [_finalWeapons select _i,_finalWeaponCount select _i];
	};
};

if (count _magazineCargo > 0) then {
	{
		_item = _x;
		if (!(_item in _finalMagazines) AND ([!(_item in unlockedMagazines),true] select activeJNA)) then {
			_finalMagazines pushBackUnique _item;
			_finalMagazineCount pushBack ({_x == _item} count _magazineCargo);
		};
	} forEach  _magazineCargo;
};



if (count _finalMagazines > 0) then {
	for "_i" from 0 to (count _finalMagazines) - 1 do {
		_targetContainer addMagazineCargoGlobal [_finalMagazines select _i,_finalMagazineCount select _i];
	};
};

if (count _itemCargo > 0) then {
	{
		_item = _x;
		if (!(_item in _finalItems) AND ([!(_item in unlockedItems),true] select activeJNA)) then {
			_finalItems pushBackUnique _item;
			_finalItemCount pushBack ({_x == _item} count _itemCargo);
		};
	} forEach _itemCargo;
};


if (count _finalItems > 0) then {
	for "_i" from 0 to (count _finalItems) - 1 do {
		_targetContainer addItemCargoGlobal [_finalItems select _i,_finalItemCount select _i];
	};
};

if (count _backpacks > 0) then {
	{
		_item = _x;
		if (!(_item in _finalBackpacks) AND ([!(_item in unlockedBackpacks),true] select activeJNA)) then {
			_finalBackpacks pushBackUnique _item;
			_finalBackpackCount pushBack ({_x == _item} count _backpacks);
		};
	} forEach _backpacks;
};

if (count _finalBackpacks > 0) then {
	for "_i" from 0 to (count _finalBackpacks) - 1 do {
		_targetContainer addBackpackCargoGlobal [_finalBackpacks select _i,_finalBackpackCount select _i];
	};
};

clearMagazineCargoGlobal _originContainer;
clearWeaponCargoGlobal _originContainer;
clearItemCargoGlobal _originContainer;
clearBackpackCargoGlobal _originContainer;


if (_targetContainer == caja) then {
	if (isMultiplayer) then {
		{
			if (_x distance caja < 10) then {
				[petros,"hint","Ammobox Loaded"] remoteExec ["commsMP",_x];
			};
		} forEach playableUnits;
	} else {
		hint "Ammobox Loaded";
	};

	if !(activeJNA) then {
		_updated = [] call AS_fnc_updateArsenal;
		if (count _updated > 0) then {
			_updated = format ["Arsenal Updated<br/><br/>%1",_updated];
			[[petros,"income",_updated],"commsMP"] call BIS_fnc_MP;
		};
	};
} else {
	[petros,"hint","Truck Loaded"] remoteExec ["commsMP",driver _targetContainer];
};