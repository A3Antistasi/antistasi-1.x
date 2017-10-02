disableSerialization;
params ["_control"];
private ["_display", "_item"];

if (ctrlIDC _control == 2130) exitWith {};

_display = findDisplay 100;

if (ctrlShown (_display displayCtrl (ctrlIDC _control + 10))) exitWith {};
for "_i" from (ctrlIDC _control + 10) to (ctrlIDC _control + 15) do {
	_display displayCtrl _i ctrlShow true;
	_display displayCtrl _i ctrlEnable true;
};

_item = _display displayCtrl (ctrlIDC _control + 10);
lbClear _item;

for "_i" from 0 to (count AS_currentClasses - 1) do {
	_item lbAdd (AS_currentDisplayNames select _i);
	_item lbSetData [(lbSize _item)-1,AS_currentClasses select _i];
};