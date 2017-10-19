(findDisplay 46) displayRemoveEventHandler ["KeyDown", gameMenu];
gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",AS_fnc_keyDownMain];

if (player != Slowhand) exitWith {};

if (count _this == 0) then {hint "Reinitialised:\n\nSpecial Keys\n\nStatistics Report"};

