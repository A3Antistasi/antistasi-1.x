params [["_force", false]];

if (_force) exitWith {
	petros setVariable ["AS_animPetros", false, true];
	[petros] remoteExec ["BIS_fnc_ambientAnim__terminate", [0,-2] select isDedicated, true];
	[] call AS_fnc_rearmPetros;
};

if (server getVariable ["AS_toggleAnim", false]) exitWith {
	[petros,"BE", "Currently changing Petros' state, try again in a few seconds."] remoteExec ["commsMP",Slowhand];
};

server setVariable ["AS_toggleAnim", true, true];

if (petros getVariable ["AS_animPetros", false]) then {
	petros setVariable ["AS_animPetros", false, true];
} else {
	[] remoteExec ["petrosAnimation", 2];
};

server setVariable ["AS_toggleAnim", nil, true];