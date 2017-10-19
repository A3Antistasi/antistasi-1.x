params [["_clean", false]];
private ["_weapons", "_magazines", "_items", "_backpacks", "_allMags", "_weapCargo", "_magCargo", "_itemCargo", "_bpCargo", "_z"];

if (_clean) then {
	[[],[],[],[],[],[],[],[],[],[]] call {
		params ["_uW", "_uM", "_uI", "_uB", "_uO", "_uR", "_uWc", "_uMc", "_uIc", "_uBc"];

		if (count unlockedWeapons > 0) then {
			for "_i" from 0 to (count unlockedWeapons - 1) do {
				_z = unlockedWeapons select _i;
				if (_z in gear_allWeapons) then {
					_uW pushBackUnique _z;
				};
			};
			unlockedWeapons = _uW;
			publicVariable "unlockedWeapons";
		};
		if (count unlockedMagazines > 0) then {
			for "_i" from 0 to (count unlockedMagazines - 1) do {
				_z = unlockedMagazines select _i;
				if (_z in gear_allMagazines) then {
					_uM pushBackUnique _z;
				};
			};
			unlockedMagazines = _uM;
			publicVariable "unlockedMagazines";
		};
		if (count unlockedItems > 0) then {
			for "_i" from 0 to (count unlockedItems - 1) do {
				_uI pushBackUnique (unlockedItems select _i);
			};
			unlockedItems = _uI;
			unlockedItems pushBackUnique "Binocular";
			publicVariable "unlockedItems";
		};
		if (count unlockedBackpacks > 0) then {
			for "_i" from 0 to (count unlockedBackpacks - 1) do {
				_uB pushBackUnique (unlockedBackpacks select _i);
			};
			unlockedBackpacks = _uB;
			publicVariable "unlockedBackpacks";
		};
		if (count unlockedOptics > 0) then {
			for "_i" from 0 to (count unlockedOptics - 1) do {
				_uO pushBackUnique (unlockedOptics select _i);
			};
			unlockedOptics = _uO;
			publicVariable "unlockedOptics";
		};
		if (count unlockedRifles > 0) then {
			for "_i" from 0 to (count unlockedRifles - 1) do {
				_z = unlockedRifles select _i;
				if (_z in gear_allWeapons) then {
					_uR pushBackUnique _z;
				};
			};
			unlockedRifles = _uR;
			publicVariable "unlockedRifles";
		};

		[[unlockedWeapons, (["primary","secondary"] call AS_fnc_JNA_getLists)] select activeJNA] spawn AS_fnc_weaponsCheck;
	};
};

0 = [] call AS_fnc_MAINT_arsInv;

// XLA fixed arsenal
if (activeXLA) then {
	_weapons = caja call XLA_fnc_getVirtualWeaponCargo;
	_magazines = caja call XLA_fnc_getVirtualMagazineCargo;
	_items = caja call XLA_fnc_getVirtualItemCargo;
	_backpacks = caja call XLA_fnc_getVirtualBackpackCargo;

	[caja,_weapons,true] call XLA_fnc_removeVirtualWeaponCargo;
	[caja,_magazines,true] call XLA_fnc_removeVirtualMagazineCargo;
	[caja,_items,true] call XLA_fnc_removeVirtualItemCargo;
	[caja,_backpacks,true] call XLA_fnc_removeVirtualBackpackCargo;

	[caja,unlockedWeapons,true,false] call XLA_fnc_addVirtualWeaponCargo;
	[caja,unlockedMagazines,true,false] call XLA_fnc_addVirtualMagazineCargo;
	[caja,unlockedItems,true,false] call XLA_fnc_addVirtualItemCargo;
	[caja,unlockedBackpacks,true,false] call XLA_fnc_addVirtualBackpackCargo;
} else {
	_weapons = caja call BIS_fnc_getVirtualWeaponCargo;
	_magazines = caja call BIS_fnc_getVirtualMagazineCargo;
	_items = caja call BIS_fnc_getVirtualItemCargo;
	_backpacks = caja call BIS_fnc_getVirtualBackpackCargo;

	[caja,_weapons,true] call BIS_fnc_removeVirtualWeaponCargo;
	[caja,_magazines,true] call BIS_fnc_removeVirtualMagazineCargo;
	[caja,_items,true] call BIS_fnc_removeVirtualItemCargo;
	[caja,_backpacks,true] call BIS_fnc_removeVirtualBackpackCargo;

	[caja,unlockedWeapons,true,false] call BIS_fnc_addVirtualWeaponCargo;
	[caja,unlockedMagazines,true,false] call BIS_fnc_addVirtualMagazineCargo;
	[caja,unlockedItems,true,false] call BIS_fnc_addVirtualItemCargo;
	[caja,unlockedBackpacks,true,false] call BIS_fnc_addVirtualBackpackCargo;
};

if !(_clean) then {[unlockedWeapons] spawn AS_fnc_weaponsCheck};

0 = [] call AS_fnc_updateArsenal;

[[petros,"hint","Arsenal synchronized"],"commsMP"] call BIS_fnc_MP;
diag_log "Maintenance: Arsenal resynchronised";