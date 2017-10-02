AS_DBcreated = nil;
[] remoteExec ["AS_fnc_createItemDB", 2];
waitUntil {sleep 1; !(isNil "AS_DBcreated")};

AS_currentlySelling = true;
publicVariable "AS_currentlySelling";

disableSerialization;
createDialog "menu_sell";
sleep 1;

A3AS_menu_escEH = (findDisplay 100) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then {closeDialog 0; AS_currentlySelling = nil; publicVariable 'AS_currentlySelling'; true}"];
["weapons"] call AS_fnc_UI_changeCategory;

_display = findDisplay 100;

_display displayCtrl 1501 ctrlAddEventHandler ["ButtonClick", "['weapons'] call AS_fnc_UI_changeCategory"];
_display displayCtrl 1502 ctrlAddEventHandler ["ButtonClick", "['magazines'] call AS_fnc_UI_changeCategory"];
_display displayCtrl 1503 ctrlAddEventHandler ["ButtonClick", "['items'] call AS_fnc_UI_changeCategory"];
_display displayCtrl 1504 ctrlAddEventHandler ["ButtonClick", "['backpacks'] call AS_fnc_UI_changeCategory"];

_item = _display displayCtrl 2100;

lbClear _item;

for "_i" from 0 to (count AS_currentClasses - 1) do {
	_item lbAdd (AS_currentDisplayNames select _i);
	_item lbSetData [(lbSize _item)-1,AS_currentClasses select _i];
};

_item ctrlAddEventHandler ["LBSelChanged", "_this call AS_fnc_UI_showCombo;"];
_display displayCtrl 1505 ctrlAddEventHandler ["ButtonClick", "[] call AS_fnc_UI_sellGear"];

{
	_display displayCtrl _x ctrlAddEventHandler ["LBSelChanged", "_this spawn AS_fnc_UI_itemSelected; _this spawn AS_fnc_UI_showCombo;"];
} forEach [2110, 2120, 2130];
