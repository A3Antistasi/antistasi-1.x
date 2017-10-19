#include "..\defines\general.hpp"

params [["_minIDC", 1510], ["_maxIDC", 1600]];
private ["_display"];

disableSerialization;

_display = findDisplay 100;

{
	_display displayCtrl _x ctrlShow false;
} forEach LINES;

{
	if ((ctrlIDC _x > _minIDC) && (ctrlIDC _x <= _maxIDC)) then {
		_x ctrlRemoveAllEventHandlers "ButtonClick";
		_x ctrlRemoveAllEventHandlers "MouseEnter";
		_x ctrlSetTextColor MENU_TEXT_COLOR_ARRAY;
		_x ctrlShow false;
		_x ctrlEnable false;
		ctrlDelete _x;};
} forEach (allControls _display);
