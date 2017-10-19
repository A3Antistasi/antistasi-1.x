params[ ["_player",objNull,[objNull]]];

diag_log format ["fn_loadPlayer.sqf: player: %1", _player];

if(!isServer)exitWith{};

["loadout",_player] call fn_loadPlayerData;

if (isMultiplayer) then {
	["score",_player] call fn_loadPlayerData;
	["rank",_player] call fn_loadPlayerData;
	["funds",_player] call fn_loadPlayerData;
};

_player setVariable ["persenalSaveLoaded",true,true];