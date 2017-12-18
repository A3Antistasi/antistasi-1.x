#include "script_component.hpp"
params[
	["_player",objNull,[objNull]],
	["_uid","",[""]],
	["_checkDistance",false,[true]]
];
LOG_1("START Saving player:%1", getPlayerUID _player);

if(!isServer)exitWith{};

//if player did not load his old gear yet, dont overwrite it with the default gear.
if!(_player getVariable ["persenalSaveLoaded",false])exitWith{};

diag_log ["saveplayer", _uid, _player];

if (isMultiplayer) then {
	private _score = _player getVariable ["score",0];
	private _rank = rank _player; //Rank is not being saved! Sparker.
	private _funds = _player getVariable ["dinero",0];

	["score",_score, _uid] call fn_savePlayerData;
	["rank",_rank, _uid] call fn_savePlayerData;
	["funds",_funds, _uid] call fn_savePlayerData;
};

//if player is to far from hq dont save his/her gear.
private _loadout = if([_player] call AS_fnc_isUnconscious OR (_checkDistance AND {(getPos _player) distance (getPos fuego) > 10000}))then{
	[[],[],[],[],[],[],"","",[],["","","","","",""]];
}else{
	getUnitLoadout _player;
};
["loadout",_loadout, _uid] call fn_savePlayerData;
LOG_1("END Saving player:%1", getPlayerUID _player);
