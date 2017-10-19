/*
 	Description:
		Mapping of internal JNA lists onto old lists

	Parameters:
		0: ARRAY/STRING - Array of strings with categories to update, or the string "complete", which will trigger a full refresh, or a string of a single category

 	Returns:
		BOOLEAN - Lists updated or not

 	Example:
		_updated = ["items"] call AS_fnc_JNA_pushLists;
*/

if !(isServer) exitWith {};

params [["_categories",[],[[],""]]];
[[],[],[],[],[],false] params ["_weapons","_rifles","_magazines","_items","_backpacks","_updated"];

if (typeName _categories == "STRING") exitWith {
	if (_categories isEqualTo "complete") then {
		_updated = [["weapons","magazines","items","backpacks"]] call AS_fnc_JNA_pushLists;
	} else {
		_updated = [[_categories]] call AS_fnc_JNA_pushLists;
	};
	_updated
};

if (typeName _categories == "ARRAY") then {
	if ("weapons" in _categories) then {
		_weapons = [["primary","secondary"],true] call AS_fnc_JNA_getLists;
		_rifles = [["primary"],true] call AS_fnc_JNA_getLists;
	};

	if ("magazines" in _categories) then {
		_magazines = [["ammo","grenade","mine"],true] call AS_fnc_JNA_getLists;
	};

	if ("items" in _categories) then {
		_items = [["vest","helmet","nvg","binos","gps","radio","optic","muzzle","accessory","bipod","misc"],true] call AS_fnc_JNA_getLists;
	};

	if ("backpacks" in _categories) then {
		_backpacks = [["backpack"],true] call AS_fnc_JNA_getLists;
	};
};

if (count _weapons > 0) then {
	unlockedWeapons = _weapons;
	publicVariable "unlockedWeapons";
	_updated = true;
};

if (count _rifles > 0) then {
	unlockedRifles = _rifles;
	publicVariable "unlockedRifles";
	_updated = true;
};

if (count _magazines > 0) then {
	unlockedMagazines = _magazines;
	publicVariable "unlockedMagazines";
	_updated = true;
};

if (count _items > 0) then {
	unlockedItems = _items;
	publicVariable "unlockedItems";
	_updated = true;
};

if (count _backpacks > 0) then {
	unlockedBackpacks = _backpacks;
	publicVariable "unlockedBackpacks";
	_updated = true;
};

_updated