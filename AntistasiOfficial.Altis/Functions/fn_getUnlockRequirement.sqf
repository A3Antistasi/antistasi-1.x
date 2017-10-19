/*
    Description:
        - Calculate the number of items currently required to unlock a specific item class

    Parameters:
        0: Item class ("weapons", "magazines", "backpacks", "items", "vests")

    Returns:
        Number required (integer)

    Example:
        _req = ["weapons"] call AS_fnc_getUnlockRequirement
*/

params ["_type"];
private ["_requirement", "_factories", "_weaponReqBase", "_itemReqBase"];

_factories = count (fabricas - mrkAAF);
_weaponReqBase = [12, 9] select activeACE;
_itemReqBase = [-58, -84] select activeACE;
if (activeACE) then {_itemReqBase = [-84, -98] select activeACEMedical};
_itemReqBase = [_itemReqBase, _itemReqBase - 10] select replaceFIA;

switch (_type) do {
	case "weapons": {
		_requirement = _weaponReqBase + (count unlockedWeapons) - (2*_factories);
	};
	case "magazines": {
		_requirement = 13 + (count unlockedMagazines) - (2*_factories);
	};
	case "backpacks": {
		_requirement = 5*(count unlockedBackpacks);
	};
	case "items": {
		_requirement = _itemReqBase + (count unlockedItems) - (2*_factories);
	};
	case "vests": {
		_requirement = _itemReqBase + (count unlockedItems) - (2*_factories) - 10;
	};

	default {
		_requirement = _itemReqBase + (count unlockedItems) - (2*_factories);
	};
};

_requirement