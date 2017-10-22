params ["_isCommander"];
private ["_veh", "_owner", "_exit"];

_veh = cursortarget;

if (isNull _veh) exitWith {hint "You are not looking at any vehicle"};
if ({isPlayer _x} count crew _veh > 0) exitWith {hint "In order to unlock this vehicle, it must be empty."};

if !(isMultiplayer) exitWith {
	if (locked _veh > 0) then {
		_veh lock 0;
		hint "Vehicle unlocked";
	} else {
		_veh lock 2;
		hint "Vehicle locked";
	};
};

_owner = _veh getVariable ["vehOwner", nil];
//Noones vehicle can be locked
if (isNil "_owner") exitWith {_veh setVariable ["vehOwner",getPlayerUID player,true]; hint "Vehicle locked";};
//Commander and owner can unlock a vehicle
if ((_isCommander) or ((getPlayerUID player) isEqualTo _owner)) exitWith {_veh setVariable ["vehOwner",nil,true]; hint "Vehicle unlocked";};
hint "You are not owner of this vehicle and you cannot unlock it";
