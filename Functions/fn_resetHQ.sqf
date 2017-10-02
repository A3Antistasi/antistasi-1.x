if !(isServer) exitWith {};

params [["_position",static_defPosHQ,[[]]]];
[petros] params ["_oldUnit"];

if (typeName _position != "ARRAY") then {
	_position = static_defPosHQ;
};

if (_position isEqualTo [0,0,0]) then {
	diag_log "Error in resetHQ: target position was defined as [0,0,0]";
	_position = static_defPosHQ;
};

grupoPetros = createGroup side_blue;
publicVariable "grupoPetros";
petros = grupoPetros createUnit [ guer_sol_OFF, _position, [], 0, "NONE" ];
grupoPetros setGroupId ["Petros","GroupColor4"];
petros setIdentity "amiguete";
petros setName "Petros";
petros forceSpeed 0;
if (group _oldUnit == grupoPetros) then {
      [Petros,"mission"] remoteExec ["AS_fnc_addActionMP"];
} else {
      [Petros,"buildHQ"] remoteExec ["AS_fnc_addActionMP"];
};
call compile preprocessFileLineNumbers "initPetros.sqf";
deleteVehicle _oldUnit;
publicVariable "petros";

AS_flag_resetDone = true;