params ["_vehicle"];

_vehicle setSpeedMode "LIMITED";
[_vehicle] spawn vehicleRemover;
_vehicle addEventHandler ["Killed",{[_this select 0] spawn postmortem}];

// Disable damage to wheels to account for limited driving skills of AI
if (_vehicle isKindOf "Car") then {
	_vehicle addEventHandler ["HandleDamage",{
		params ["_unit","_part","_damage","_source","_projectile"];
		_unit = _this select 0;
	_part = _this select 1;
	_damage = _this select 2;
	_source = _this select 3;
	_projectile = _this select 4;
		if ((_part find "wheel" != -1) AND (_projectile =="") AND !(isPlayer driver _unit)) then {0} else {_damage};
	}];
};

if (count crew _vehicle == 0) then {
	sleep 10;
	_vehicle enableSimulationGlobal false;
	_vehicle addEventHandler ["GetIn",{
		params ["_object"];
		if !(simulationEnabled _object) then {_object enableSimulationGlobal true};
		[_object] spawn VEHdespawner;
	}];
	_vehicle addEventHandler ["HandleDamage",{
		params ["_object"];
		if (!simulationEnabled _object) then {_object enableSimulationGlobal true};
	}];
};