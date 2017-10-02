disableSerialization;
private ["_idc", "_countidc", "_comboidc", "_countctrl", "_comboctrl", "_newcount"];
params ["_control"];

_idc = ctrlIDC _control;
_display = findDisplay 100;

_countidc = _idc - 1;
_comboidc = _idc - 3;

_comboctrl = _display displayCtrl _comboidc;
_countctrl = _display displayCtrl _countidc;
_newcount = (parseNumber ctrlText _countctrl) + 1;

if (_newcount <= (AS_weaponCounts select (lbCurSel _comboctrl))) then {
	_countctrl ctrlSetText format["%1", _newcount];
};