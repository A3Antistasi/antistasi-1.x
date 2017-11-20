params [["_FIA", false]];
private ["_veh","_vehType", "_permission", "_text"];


if (server getVariable ["lockTransfer",false]) exitWith {
	{
		if (_x distance caja < 20) then {
			[petros,"hint","Currently unloading another ammobox. Please wait a few seconds."] remoteExec ["commsMP",_x];
		};
	} forEach playableUnits;
};

[cursorobject,true] call vaciar;
cursorobject call jn_fnc_garage_garageVehicle;