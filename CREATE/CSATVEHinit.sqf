params ["_vehicle"];
private ["_crewPos","_unit"];

if (_vehicle isKindOf "Air") then {
	_vehicle addEventHandler ["GetIn", {
		_crewPos = _this select 1;
		if (_crewPos == "driver") then {
			_unit = _this select 2;
			if ((!isPlayer _unit) AND (_unit getVariable ["BLUFORSpawn",false])) then {
				moveOut _unit;
				hint format ["AI is not capable of flying %1 vehicles.", A3_Str_RED];
			};
		};
	}];
};

_vehicle addEventHandler ["killed", {
	if (side (_this select 1) == side_blue) then {
		[0,0] remoteExec ["prestige",2];
		[-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
		if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
	};
}];

[_vehicle] spawn vehicleRemover;

if ((count crew _vehicle) > 0) then {
	[_vehicle] spawn VEHdespawner
} else {
	_vehicle addEventHandler ["GetIn", {
		_vehicle = _this select 0;
		[_vehicle] spawn VEHdespawner;
	}];
};