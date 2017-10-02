/*
    Description:
        - Removes a set of items from a single category from the arsenal ammo box

    Parameters:
        0: Item category ("weapons", "magazines", "items", "backpacks")
        1: Item array: [[item classes], [corresponding item numbers]]

    Returns:
        Nothing

    Example:
        ["weapons", [["arifle_TRG21_F", "srifle_EBR_F"], [1, 4]]] call AS_fnc_removeGear
*/

if !(isServer) exitWith {};

params ["_type", "_itemArray"];
private ["_items", "_itemCounts", "_tempArray"];

_items = _itemArray select 0;
_itemCounts = _itemArray select 1;

_tempArray = [];
switch (_type) do {
	case "weapons": {
		_tempArray = weaponCargo caja;
	};
	case "magazines": {
		_tempArray = magazineCargo caja;
	};
	case "items": {
		_tempArray = itemCargo caja;
	};
	case "backpacks": {
		_tempArray = backpackCargo caja;
	};
	default {
		_tempArray = [];
	};
};

for "_i" from 0 to (count _items - 1) do {
	for "_j" from 0 to ((_itemCounts select _i) - 1) do {
		_index = _tempArray find (_items select _i);
		if (_index > -1) then {
			_tempArray set [_index, -1];
			_tempArray = _tempArray - [-1];
		};
	};
};

switch (_type) do {
	case "weapons": {
		clearWeaponCargoGlobal caja;
		{caja addWeaponCargoGlobal[_x,1]} forEach _tempArray;
	};
	case "magazines": {
		clearMagazineCargoGlobal caja;
		{caja addMagazineCargoGlobal[_x,1]} forEach _tempArray;
	};
	case "items": {
		clearItemCargoGlobal caja;
		{caja addItemCargoGlobal[_x,1]} forEach _tempArray;
	};
	case "backpacks": {
		clearBackpackCargoGlobal caja;
		{caja addBackpackCargoGlobal[_x,1]} forEach _tempArray;
	};
	default {
		diag_log "Maintenance -- failure in AS_fnc_removeGear";
	};
};

AS_removingGear = nil;
publicVariable "AS_removingGear";
[_type] call AS_fnc_createItemDB;

["weapons"] call AS_fnc_UI_changeCategory;