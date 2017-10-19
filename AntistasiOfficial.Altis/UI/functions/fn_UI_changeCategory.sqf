disableSerialization;
params ["_category"];
private ["_item", "_display"];

_display = findDisplay 100;

call {
	if (_category == "weapons") exitWith {
		AS_currentClasses = AS_weaponClasses;
		AS_currentDisplayNames = AS_weaponDisplayNames;
		AS_currentCounts = AS_weaponCounts;
		_display displayCtrl 1202 ctrlSetText localize "STR_UI_SELL_WEAPONS";
	};

	if (_category == "magazines") exitWith {
		AS_currentClasses = AS_magazineClasses;
		AS_currentDisplayNames = AS_magazineDisplayNames;
		AS_currentCounts = AS_magazineCounts;
		_display displayCtrl 1202 ctrlSetText localize "STR_UI_SELL_AMMO";
	};

	if (_category == "items") exitWith {
		AS_currentClasses = AS_itemClasses;
		AS_currentDisplayNames = AS_itemDisplayNames;
		AS_currentCounts = AS_itemCounts;
		_display displayCtrl 1202 ctrlSetText localize "STR_UI_SELL_ITEMS";
	};

	if (_category == "backpacks") exitWith {
		AS_currentClasses = AS_backpackClasses;
		AS_currentDisplayNames = AS_backpackDisplayNames;
		AS_currentCounts = AS_backpackCounts;
		_display displayCtrl 1202 ctrlSetText localize "STR_UI_SELL_BACKPACKS";
	};
};

AS_currentCategory = _category;

publicVariable "AS_currentClasses";
publicVariable "AS_currentDisplayNames";
publicVariable "AS_currentCounts";
publicVariable "AS_currentCategory";

_item = _display displayCtrl 2100;

lbClear _item;
_item lbSetCurSel -1;
for "_i" from 0 to (count AS_currentClasses - 1) do {
	_item lbAdd (AS_currentDisplayNames select _i);
	_item lbSetData [(lbSize _item)-1,AS_currentClasses select _i];
};

{
	_display displayCtrl _x ctrlRemoveAllEventHandlers "LBSelChanged";
	lbClear (_display displayCtrl _x);
	_display displayCtrl _x lbSetCurSel -1;
	_display displayCtrl _x ctrlAddEventHandler ["LBSelChanged", "_this spawn AS_fnc_UI_itemSelected; _this spawn AS_fnc_UI_showCombo;"];
} forEach [2110, 2120, 2130];

{
	_display displayCtrl _x ctrlSetText "1";
} forEach [2112, 2122, 2132];

for "_i" from (2100 + 10) to (2100 + 35) do {
	_display displayCtrl _i ctrlShow false;
	_display displayCtrl _i ctrlEnable false;
};