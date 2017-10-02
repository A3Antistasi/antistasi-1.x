createDialog "first_load";

_bypass = false;

if (count _this > 0) then {_bypass = true};
//bypass es true cuando un JIP carga
waitUntil {dialog};
waitUntil {!dialog};
//sleep 1;
if ((!dialog) and (!visibleMap) and (isNil "statsLoaded") and (player == Slowhand) and (!_bypass) and (isNil "placementDone")) then
	{
	[] spawn placementSelection;
	};