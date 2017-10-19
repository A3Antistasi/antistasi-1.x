if !(isServer) exitWith {};

params [["_category", "all"]];
private ["_weaponData", "_magazineData", "_itemData", "_backpackData", "_updateWeapons", "_updateMagazines", "_updateItems", "_updateBackpacks"];

_updateWeapons = {
	_weaponData = getWeaponCargo caja;
	AS_weaponClasses = _weaponData select 0;
	AS_weaponCounts = _weaponData select 1;
	AS_weaponDisplayNames = [];
	{
		AS_weaponDisplayNames pushBackUnique (getText (configFile >> "CfgWeapons" >> _x >> "displayName"));
	} forEach AS_weaponClasses;
	publicVariable "AS_weaponClasses";
	publicVariable "AS_weaponDisplayNames";
	publicVariable "AS_weaponCounts";
};

_updateMagazines = {
	_magazineData = getMagazineCargo caja;
	AS_magazineClasses = _magazineData select 0;
	AS_magazineCounts = _magazineData select 1;
	AS_magazineDisplayNames = [];
	{
		AS_magazineDisplayNames pushBackUnique (getText (configFile >> "CfgMagazines" >> _x >> "displayName"));
	} forEach AS_magazineClasses;
	publicVariable "AS_magazineClasses";
	publicVariable "AS_magazineDisplayNames";
	publicVariable "AS_magazineCounts";
};

_updateItems = {
	_itemData = getItemCargo caja;
	AS_itemClasses = _itemData select 0;
	AS_itemCounts = _itemData select 1;
	AS_itemDisplayNames = [];
	{
		AS_itemDisplayNames pushBackUnique (getText (configFile >> "CfgWeapons" >> _x >> "displayName"));
	} forEach AS_itemClasses;
	publicVariable "AS_itemClasses";
	publicVariable "AS_itemDisplayNames";
	publicVariable "AS_itemCounts";
};

_updateBackpacks = {
	_backpackData = getBackpackCargo caja;
	AS_backpackClasses = _backpackData select 0;
	AS_backpackCounts = _backpackData select 1;
	AS_backpackDisplayNames = [];
	{
		AS_backpackDisplayNames pushBackUnique (getText (configFile >> "CfgVehicles" >> _x >> "displayName"));
	} forEach AS_backpackClasses;
	publicVariable "AS_backpackClasses";
	publicVariable "AS_backpackDisplayNames";
	publicVariable "AS_backpackCounts";
};

call {
	if (_category == "weapons") exitWith {
		call _updateWeapons;
	};
	if (_category == "magazines") exitWith {
		call _updateMagazines;
	};
	if (_category == "items") exitWith {
		call _updateItems;
	};
	if (_category == "backpacks") exitWith {
		call _updateBackpacks;
	};
	if (_category == "all") exitWith {
		call _updateWeapons;
		call _updateMagazines;
		call _updateItems;
		call _updateBackpacks;

		AS_DBcreated = true;
		publicVariable "AS_DBcreated";
	};
};