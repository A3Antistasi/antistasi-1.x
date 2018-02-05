params ["_vehicle"];
private ["_vehicleType","_eh","_mortar","_leader","_tempVehicle"];

_vehicle setfuel 0.1;
if(activeACE) then {[_vehicle, 300] call ace_refuel_fnc_setFuel;} else {_vehicle setfuelcargo 0.1;};

if ((_vehicle isKindOf "FlagCarrier") OR (_vehicle isKindOf "Building")) exitWith {};
if (_vehicle isKindOf "ReammoBox_F" && ((_vehicle getVariable ["HQ_vehicle", 0]) == 0)) exitWith {[_vehicle] call cajaAAF};

if ((activeACE) AND !(random 3 > 2)) then {_vehicle setVariable ["ace_cookoff_enable", false, true]};

if (_vehicle isKindOf "Car") then {
	_vehicle addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
};

if(_vehicle iskindof "thing") then {_vehicle call jn_fnc_logistics_addAction};

_vehicleType = typeOf _vehicle;

call {
	if (_vehicleType in (vehNATO+planesNATO)) exitWith {
		clearMagazineCargoGlobal _vehicle;
		clearWeaponCargoGlobal _vehicle;
		clearItemCargoGlobal _vehicle;
		clearBackpackCargoGlobal _vehicle;
		_vehicle lock 3;
		_vehicle addEventHandler ["GetIn", {
			_unit = _this select 2;
			if ({isPlayer _x} count units group _unit > 0) then {moveOut _unit;};
		}];
		_vehicle addEventHandler ["killed",{
			[-2,0] remoteExec ["prestige",2];
			[2,-2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
		}];
	};

	if (_vehicleType in (vehTrucks+vehPatrol+vehSupply+enemyMotorpool+vehPatrolBoat)) exitWith {
		if !(_vehicleType in enemyMotorpool) then {
			if (_vehicleType == vehAmmo) then {
				if (_vehicle distance getMarkerPos guer_respawn > 50) then {[_vehicle] call cajaAAF};
			};
			_vehicle addEventHandler ["killed",{
				[-1000] remoteExec ["resourcesAAF",2];
				if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
			}];
		} else {
			if (_vehicleType in (vehAPC+vehIFV)) then {
				_vehicle addEventHandler ["killed",{
					[_this select 0] call AS_fnc_AAFassets;
					[-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
					if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
				}];
				//_vehicle addEventHandler ["HandleDamage",{private ["_vehicle"]; _vehicle = _this select 0; if (_this select 1 == "") then {if ((_this select 2 > 0.9) and (!isNull driver _vehicle)) then {[_vehicle] call smokeCoverAuto}}}

			};

			if (_vehicleType in vehTank) then {
				_vehicle addEventHandler ["killed",{
					[_this select 0] call AS_fnc_AAFassets;
					[-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
					if (activeBE) then {["des_arm"] remoteExec ["fnc_BE_XP", 2]};
				}];
				//_vehicle addEventHandler ["HandleDamage",{private ["_vehicle"]; _vehicle = _this select 0; if (_this select 1 == "") then {if ((_this select 2 > 0.9) and (!isNull driver _vehicle)) then {[_vehicle] call smokeCoverAuto


			};
		};
	};

	if ((_vehicleType in (indAirForce+opAir)) OR (_vehicleType == civHeli)) exitWith {
		_vehicle addEventHandler ["GetIn", {
			_position = _this select 1;
			if (_position == "driver") then {
				_unit = _this select 2;
				if ((!isPlayer _unit) AND (_unit getVariable ["BLUFORSpawn",false])) then {
					moveOut _unit;
					hint "Only Humans can pilot an air vehicle";
				};
			};
		_vehicle setfuel 0.3;
		}];

		if (_vehicleType in heli_unarmed) then {
			_vehicle addEventHandler ["killed",{
				[-4000] remoteExec ["resourcesAAF",2];
				if (activeBE) then {["des_veh"] remoteExec ["fnc_BE_XP", 2]};
			}];
		} else {
			if !(_vehicleType in opAir) then {
				if (_vehicle isKindOf "Helicopter") then {_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets;[1,0] remoteExec ["prestige",2]; [-2,2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]};
				if (_vehicle isKindOf "Plane") then {_vehicle addEventHandler ["killed",{[_this select 0] call AS_fnc_AAFassets;[2,0] remoteExec ["prestige",2]; [-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}]};
			} else {
				_vehicle addEventHandler ["killed",{[2,0] remoteExec ["prestige",2]; [-5,5,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2]}];
			};
		};
	};

	if (_vehicleType == indUAV_large) exitWith {
		_vehicle addEventHandler ["killed",{[-2500] remoteExec ["resourcesAAF",2]}];
	};

	if ((_vehicle isKindOf "StaticWeapon") AND !(_vehicle in staticsToSave) AND !(_vehicleType in statics_allMortars) AND ((side gunner _vehicle == side_green) OR (side gunner _vehicle == side_red))) exitWith {
		[[_vehicle,"steal"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
	};

	if (_vehicleType in statics_allMortars) exitWith {
		if (!isNull gunner _vehicle) then {[[_vehicle,"steal"],"AS_fnc_addActionMP"] call BIS_fnc_MP};
		_eh = _vehicle addEventHandler ["Fired", {
			if (random 8 < 1) then {
				_mortar = _this select 0;
				if (_mortar distance posHQ < 200) then {
					if !("DEF_HQ" in misiones) then {
						_leader = leader (gunner _mortar);
						if (!isPlayer _leader) then {
							[] remoteExec ["ataqueHQ", call AS_fnc_getNextWorker];
						} else {
							if ([_leader] call isMember) then {[] remoteExec ["ataqueHQ", call AS_fnc_getNextWorker]};
						};
					};
				} else {
					[position _mortar] remoteExec ["patrolCA", call AS_fnc_getNextWorker];
				};
			};
		}];
	};
};

[_vehicle] spawn vehicleRemover;
_vehicle addEventHandler ["Killed",{[_this select 0] remoteExec ["postmortem",2]}];

if !(_vehicle in staticsToSave) then {
	if ((count crew _vehicle) > 0) then {
		[_vehicle] spawn VEHdespawner
	} else {
		if (_vehicle distance getMarkerPos guer_respawn > 50) then {
			if (_vehicleType in (CIV_vehicles + [civHeli])) then {
				sleep 10;
				_vehicle enableSimulationGlobal false;
				_vehicle addEventHandler ["HandleDamage", {
					_tempVehicle = _this select 0;
					if (!simulationEnabled _tempVehicle) then {_tempVehicle enableSimulationGlobal true};
				}];
			};
			_vehicle addEventHandler ["GetIn", {
				_tempVehicle = _this select 0;
				if (!simulationEnabled _tempVehicle) then {_tempVehicle enableSimulationGlobal true};
				[_tempVehicle] spawn VEHdespawner;
			}];
		} else {
			clearMagazineCargoGlobal _vehicle;
			clearWeaponCargoGlobal _vehicle;
			clearItemCargoGlobal _vehicle;
			clearBackpackCargoGlobal _vehicle;
		};
	};
};