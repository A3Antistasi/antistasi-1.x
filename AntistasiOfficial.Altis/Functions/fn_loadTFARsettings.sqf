params ["_unit"];
private _settings = [];
private _text = "";

sleep 3;

_settings = _unit getVariable ["AS_TFAR_Settings_SW", []];
if (count _settings > 0) then {
	[((_unit call TFAR_fnc_radiosList) select 0), _settings] call TFAR_fnc_setSwSettings;
	_text = "TFAR SR Radio Settings Loaded";
};

_settings = _unit getVariable ["AS_TFAR_Settings_LR", []];
if (count _settings > 0) then {
	if (count (_unit call TFAR_fnc_backpackLR) > 0) then {
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _settings] call TFAR_fnc_setLrSettings;
		_text = format ["TFAR LR Radio Settings Loaded.\n%1", _text];
	};
};

hint _text;