params ["_unit"];
private _settings = [];
private _text = "";
if (count (_unit call TFAR_fnc_radiosList) > 0) then {
	_settings = ((_unit call TFAR_fnc_radiosList) select 0) call TFAR_fnc_getSwSettings;
	_unit setVariable ["AS_TFAR_Settings_SW", _settings, true];
	_text = "TFAR SR Radio Settings Saved";
};

if (count (_unit call TFAR_fnc_backpackLR) > 0) then {
	_settings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
	_unit setVariable ["AS_TFAR_Settings_LR", _settings, true];
	_text = format ["TFAR LR Radio Settings Saved.\n%1", _text];
};

hint _text;