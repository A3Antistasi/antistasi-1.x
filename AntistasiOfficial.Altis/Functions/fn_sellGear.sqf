/*
    Description:
        - Calculates price and sells gear

    Parameters:
        0: Item category ("weapons", "magazines", "items", "backpacks")
        1: Item array: [[item classes], [corresponding item numbers]]

    Returns:
        Nothing

    Example:
        ["weapons", [["arifle_TRG21_F", "srifle_EBR_F"], [1, 4]]] call AS_fnc_sellGear
*/

params ["_type", "_itemArray"];
private ["_items", "_itemCounts", "_price", "_total", "_friendlyHarbours"];

_items = _itemArray select 0;
_itemCounts = _itemArray select 1;

_price = 5;
_total = 0;

call {
	if (_type == "Weapons") exitWith {
		_price = 25;
	};
};

_friendlyHarbours = count (puestos - mrkAAF);
if (_friendlyHarbours > 0) then {_price = _price * ((1.1)^_friendlyHarbours)};

for "_i" from 0 to (count _items - 1) do {
	if !((_items select _i) in basicGear) then {
		_total = _total + (_price * (_itemCounts select _i));
	};
};

diag_log format ["Sum: %1; items: %2; number: %3; category: %4", _total, _items, _itemCounts, AS_currentCategory];

[0, _total] call resourcesFIA;

[AS_currentCategory, [_items, _itemCounts]] call AS_fnc_removeGear;