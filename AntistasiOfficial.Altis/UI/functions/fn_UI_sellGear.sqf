disableSerialization;
private ["_display", "_cBoxIDCs", "_items", "_itemCounts", "_item"];

_display = findDisplay 100;
_cBoxIDCs = [2100];

{
	if (ctrlShown (_display displayCtrl _x)) then {_cBoxIDCs pushBackUnique _x};
} forEach [2110, 2120, 2130];

_items = [];
_itemCounts = [];
{
	_item = (_display displayCtrl _x) lbData (lbCurSel _x);
	if !(_item == "") then {
		_items pushBackUnique _item;
		_countctrl = _display displayCtrl (_x + 2);
		_itemCounts pushBack (parseNumber ctrlText _countctrl);
	};
} forEach _cBoxIDCs;

["weapons", [_items, _itemCounts]] remoteExec ["AS_fnc_sellGear", 2];
AS_removingGear = true;
publicVariable "AS_removingGear";