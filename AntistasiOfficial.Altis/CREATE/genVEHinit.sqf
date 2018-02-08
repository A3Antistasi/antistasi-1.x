params ["_vehicle"];
private ["_vehicleType"];



if ((_vehicle isKindOf "FlagCarrier") OR (_vehicle isKindOf "Building")) exitWith {};
if (_vehicle isKindOf "ReammoBox_F") exitWith {[_vehicle] call cajaAAF};
_vehicle setfuel 0.15;
if(activeACE) then {[_vehicle, 4000] call ace_refuel_fnc_setFuel;} else {_vehicle setfuelcargo 0.6;};

_vehicleType = typeOf _vehicle;

if ((activeACE) AND (random 8 < 7)) then {_vehicle setVariable ["ace_cookoff_enable", false, true]};

call {
	// APC + IFV
	if (_vehicleType in (vehAPC+vehIFV)) exitWith {
		_vehicle addEventHandler ["killed",{
			if (side (_this select 1) == side_blue) then {
				[_this select 0] call AS_fnc_AAFassets;
				[-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
				if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
			}
		}];
		//_vehicle addEventHandler ["HandleDamage",{_vehicle = _this select 0; if (!canFire _vehicle) then {//[_vehicle] call smokeCoverAuto}}];
	};

	// tank
	if (_vehicleType in vehTank) exitWith {
		_vehicle addEventHandler ["killed",{
			if (side (_this select 1) == side_blue) then {
				[_this select 0] call AS_fnc_AAFassets; call AS_fnc_AAFassets;
				[-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
				if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
			}
		}];
		//_vehicle addEventHandler ["HandleDamage",{_vehicle = _this select 0; if (!canFire _vehicle) then {//[_vehicle] call smokeCoverAuto}}];
	};

	// plane or helicopter
	if (_vehicleType in indAirForce) exitWith {
		_vehicle setfuel 0.4;
		_vehicle addEventHandler ["GetIn", {
			_crewPos = _this select 1;
			if (_crewPos == "driver") then {
				_unit = _this select 2;
				if ((!isPlayer _unit) AND (_unit getVariable ["BLUFORSpawn",false])) then {
					moveOut _unit;
					hint format ["AI is not capable of flying %1 vehicles.", A3_Str_INDEP];
				};
			};
		}];

		if (_vehicleType in heli_unarmed) then {
			_vehicle addEventHandler ["killed",{
				[-4000] remoteExec ["resourcesAAF",2];
				if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
			}];
		} else {
			if (_vehicle isKindOf "Helicopter") then {
					_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets;[0,0] remoteExec ["prestige",2]; [-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]
			};
			if (_vehicle isKindOf "Plane") then {
				_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets; [0,0] remoteExec ["prestige",2]; [-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]
			};
		};
	};

	// UAV
	if (_vehicleType == indUAV_large) exitWith {
		_vehicle addEventHandler ["killed",{[-2500] remoteExec ["resourcesAAF",2]}];
	};

	// static weapon
	if (_vehicle isKindOf "StaticWeapon") exitWith {
		[_vehicle,"steal"] remoteExec ["AS_fnc_addActionMP",[0,-2] select isDedicated,true];
	};

	// vehicle not chosen from the available motorpool
	if !(_vehicleType in enemyMotorpool) exitWith {
		// ammo truck
		if (_vehicleType == vehAmmo) then {
			if (_vehicle distance getMarkerPos guer_respawn > 50) then {[_vehicle] call cajaAAF};
		};

		// MRAP
		if (_vehicle isKindOf "Car") then {
			_vehicle addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
		};

		_vehicle addEventHandler ["killed",{
			[-1000] remoteExec ["resourcesAAF",2];
			if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
		}];
	};
};

[_vehicle] spawn vehicleRemover;

if ((count crew _vehicle) > 0) then {
	[_vehicle] spawn VEHdespawner
} else {
	_vehicle addEventHandler ["GetIn", {
		_vehicle = _this select 0;
		[_vehicle] spawn VEHdespawner;
	}];
};
