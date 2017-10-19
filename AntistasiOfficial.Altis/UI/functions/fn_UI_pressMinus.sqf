disableSerialization;
private ["_idc", "_countidc", "_comboidc", "_countctrl", "_comboctrl"];
params ["_control"];

_idc = ctrlIDC _control;
_display = findDisplay 100;

_countidc = _idc + 1;
_comboidc = _idc - 1;

_comboctrl = _display displayCtrl _comboidc;
_countctrl = _display displayCtrl _countidc;
_newcount = (parseNumber ctrlText _countctrl) - 1;
_countctrl ctrlSetText format["%1", _newcount];

if (_newcount == 0) then {
	_comboctrl lbSetCurSel 0;
};