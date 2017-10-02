params ["_control", "_key", "_shift", "_ctrl", "_alt"];

if (player getVariable ["inconsciente",false]) exitWith {false};
if (player getVariable ["owner",player] != player) exitWith {false};

call {
	if (_key == 21) exitWith {
		if (_shift) then {
			if (player == Slowhand) then {
				if (_ctrl) then {
					CreateDialog "com_menu";
				} else {
					[] spawn artySupport;
				};
			};
		} else {
			createDialog "menu_default";
			["nav"] call AS_fnc_UI_createMenu;
		};
	};

	if (server getVariable ["testMode",false]) then {
		if (_key == 76) exitWith {
			if (_ctrl && _shift) then {
				[] spawn teleport;
			};
		};
	};

	if (isMultiplayer) then {
		if (_key == 207) exitWith {
			if (!activeACEhearing) then {
				if (soundVolume <= 0.5) then {
					0.5 fadeSound 1;
					hintSilent "You've taken out your ear plugs.";
				} else {
					0.5 fadeSound 0.1;
					hintSilent "You've inserted your ear plugs.";
				};
			};
		};
	};

	if !(isMultiplayer) then {
		if (!activeACEhearing) exitWith {
			if (_key == 207) then {
				0.5 fadeSound 0.1;
				hintSilent "You've inserted your ear plugs.";
			};
			if (_key == 199) then {
				0.5 fadeSound 1;
				hintSilent "You've taken out your ear plugs.";
			};
		};
	};
};

false