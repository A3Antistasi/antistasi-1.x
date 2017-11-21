(findDisplay 46) displayRemoveEventHandler ["KeyDown", gameMenu];
gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",AS_fnc_keyDownMain];

if (player != Slowhand) exitWith {};

if (_this isEqualTo []) then {hint "Reinitialised:\n\nSpecial Keys\n\nStatistics Report"};

