
// Remove undercover status if player fires weapons near hostiles, plus a chance to be reported in towns with high enemy support levels
player addEventHandler ["FIRED", {
	params ["_player"];

	if (captive _player) then {
		if ({((side _x== side_red) OR (side _x== side_green)) AND ((_x knowsAbout player > 1.4) OR (_x distance player < (1.5*safeDistance_undercover)))} count allUnits > 0) then {
			_player setCaptive false;
			if (vehicle _player != _player) then {
				{
					if (isPlayer _x) then {
						[_x,false] remoteExec ["setCaptive",_x];
					}
				} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
			};
		} else {
			private ["_city","_size","_data"];
			_city = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_city] call sizeMarker;
			_data = server getVariable _city;
			if (random 100 < _data select 2) then {
				if (_player distance getMarkerPos _city < _size * 1.5) then {
					_player setCaptive false;
					if (vehicle _player != _player) then {
						{
							if (isPlayer _x) then {
								[_x,false] remoteExec ["setCaptive",_x];
							}
						} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
					};
				};
			};
		};
	};
}];

// Remove undercover status if you heal someone while being known to the enemy, plus a chance to be reported in towns with high enemy support levels
player addEventHandler ["HandleHeal", {
	params ["_player"];

	if (captive _player) then {
		if ({((side _x== side_red) OR (side _x== side_green)) AND (_x knowsAbout player > 1.4)} count allUnits > 0) then {
			_player setCaptive false;
		} else {
			private ["_city","_size","_data"];
			_city = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_city] call sizeMarker;
			_data = server getVariable _city;
			if (random 100 < _data select 2) then {
				if (_player distance getMarkerPos _city < _size * 1.5) then {
					_player setCaptive false;
				};
			};
		};
	};
}];

// If you assemble a static weapon, you'll be able to move it around, and it will be added to the list of statics to save
player addEventHandler ["WeaponAssembled",{
	params ["_EHunit", "_EHobj"];
	if (_EHobj isKindOf "StaticWeapon") then {
		_EHobj addAction [localize "STR_ACT_MOVEASSET", {[_this select 0,_this select 1,_this select 2,"static"] spawn AS_fnc_moveObject},nil,0,false,true,"","(_this == Slowhand)"];
		if !(_EHobj in staticsToSave) then {
			staticsToSave pushBackUnique _EHobj;
			publicVariable "staticsToSave";
			[_EHobj] spawn VEHinit;
		};
	} else {
		_EHobj addEventHandler ["Killed",{[_this select 0] remoteExec ["postmortem",2]}];
	};
}];

// Despawn bags of disassembled statics
player addEventHandler ["WeaponDisassembled", {
	params ["_object","_bagOne","_bagTwo"];
	staticsToSave = staticsToSave - [cursorTarget];
	publicVariable "staticsToSave";
	[_bagOne] spawn VEHinit;
	[_bagTwo] spawn VEHinit;
}];

// Prevent players from getting into other players' personal vehicles, activate undercover if it's a civilian vehicle, add loading action if it's a truck
player addEventHandler ["GetInMan", {
	params ["_unit","_position","_vehicle"];
	[false] params ["_exit"];
	private ["_owner"];

	if (isMultiplayer) then {
		_owner = _vehicle getVariable ["vehOwner",getPlayerUID player];
		if (_owner != (getPlayerUID player)) then {
			if ({getPlayerUID _x == _owner} count (units group player) == 0) then {
				hint localize "STR_HINTS_GEN_EH_VEH_GROUP";
				moveOut _unit;
				_exit = true;
			};
		};
	};

	if (!_exit) then {
		if (((typeOf _vehicle) in CIV_vehicles) OR ((typeOf _vehicle) == civHeli)) then {
			if !(_vehicle in reportedVehs) then {
				[] spawn undercover;
			};
		};

		//Remove previous loading script, because we switched to jeroen's loading script. Sparker.
		/*
		if (_vehicle isKindOf "Truck_F") then {
			if !(typeOf _vehicle in ["C_Van_01_fuel_F","I_Truck_02_fuel_F","B_G_Van_01_fuel_F"]) then {
				if (_this select 1 == "driver") then {
					_EHid = _unit addAction [localize "STR_ACT_LOADAMMOBOX", "Municion\transfer.sqf",nil,0,false,true];
					_unit setVariable ["eh_transferID", _EHid, true];
				};
			};
		};
		*/
	};
}];

//Remove previous loading script, because we switched to jeroen's loading script. Sparker.
/*
// Remove the loading action
player addEventHandler ["GetOutMan",{
	if !((player getVariable ["eh_transferID", -1]) == -1) then {
		player removeaction (player getVariable "eh_transferID");
		player setVariable ["eh_transferID", nil, true];
	};
}];
*/

// If Jeroen's arsenal isn't active, display unlock requirements
if !(activeJNA) then {
	caja addEventHandler ["ContainerOpened", {
		hint format [localize "STR_HINTS_GEN_INIT_MEMBER_GEAR",
			["weapons"] call AS_fnc_getUnlockRequirement,
			["magazines"] call AS_fnc_getUnlockRequirement,
			["vests"] call AS_fnc_getUnlockRequirement,
			["items"] call AS_fnc_getUnlockRequirement,
			["backpacks"] call AS_fnc_getUnlockRequirement,
			(["items"] call AS_fnc_getUnlockRequirement) + 10];
	}];
};


// Set driver unconscious when too much damage was received -- currently unused
/*if (activeACE) then {
	player addEventHandler ["GetInMan", {
		params ["_unit","_position","_vehicle"];
		_unit = _this select 0;
		_vehicle = _this select 2;
		_testEH = _unit addEventHandler ["HandleDamage", {
			params ["_unit","_part","_damage"];
			if (_damage > 0.9) then {
				player setVariable ["ACE_isUnconscious",true,true];
				player setCaptive true;
				0.9
			} else {
				_damage
			};
		}];
		_unit setVariable ["eh_testEH", _testEH, true];
	}];

	player addEventHandler ["GetOutMan", {
		if !((player getVariable ["eh_testEH", -1]) == -1) then {
			player removeEventHandler ["HandleDamage", (player getVariable ["eh_testEH", -1])];
			player setVariable ["eh_testEH", nil, true];
		};
	}];
};*/

// Hooks for the weapon proficiency system
	call {
		player addEventHandler ["InventoryClosed", {
			[] spawn AS_fnc_skillAdjustments;

		}];

		player addEventHandler ["Take",{
		    [] spawn AS_fnc_skillAdjustments;
		}];

		[missionNamespace, "arsenalClosed", {
			[] spawn AS_fnc_skillAdjustments;
		}] call BIS_fnc_addScriptedEventHandler;
	};

if (isMultiplayer) then {
	// If you use live explosives near Petros, they will be deleted, and you will be punished
	player addEventHandler ["Fired", {
		params ["_unit","_weapon"];
		_weapon = _this select 1;
		if ((_weapon == "Put") OR (_weapon == "Throw")) then {
			if (player distance petros < 50) then {
				deleteVehicle (_this select 6);
				if (_weapon == "Put") then {
					if (player distance petros < 10) then {
						[player,60] spawn AS_fnc_punishPlayer;
					};
				};
			};
		};
	}];



	// Access restrictions if Jeroen's Arsenal is not active
	if !(activeJNA) then {
		caja addEventHandler ["ContainerOpened", {
			params ["_container","_player"];
		    if !([_player] call isMember) then {
		    	_player setPos position petros;
				hint format [localize "STR_HINTS_GEN_INIT_NOTMEMBER_GEAR",
					["weapons"] call AS_fnc_getUnlockRequirement,
					["magazines"] call AS_fnc_getUnlockRequirement,
					["vests"] call AS_fnc_getUnlockRequirement,
					["items"] call AS_fnc_getUnlockRequirement,
					["backpacks"] call AS_fnc_getUnlockRequirement,
					(["items"] call AS_fnc_getUnlockRequirement) + 10];
		    };
		}];
	    player addEventHandler ["InventoryOpened", {
			_control = false;
			if !([_this select 0] call isMember) then {
				if ((_this select 1 == caja) OR ((_this select 0) distance caja < 3)) then {
					_control = true;
					hint format [localize "STR_HINTS_GEN_INIT_NOTMEMBER_GEAR",
						["weapons"] call AS_fnc_getUnlockRequirement,
						["magazines"] call AS_fnc_getUnlockRequirement,
						["vests"] call AS_fnc_getUnlockRequirement,
						["items"] call AS_fnc_getUnlockRequirement,
						["backpacks"] call AS_fnc_getUnlockRequirement,
						(["items"] call AS_fnc_getUnlockRequirement) + 10];
				};
			};
			_control
		}];
	};
};