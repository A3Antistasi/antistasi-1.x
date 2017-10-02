params[
	["_player",objNull,[objNull]],
	["_uid","",[""]],
	["_checkDistance",false,[true]]
];

//PLAYER_SAVE_TYPES =  ["loadout","score","rank","funds"];


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
private _loadout = if(_checkDistance && ((getPos _player) distance (getPos fuego) > 10000))then{ //Sparker changed the radius to 10km range
	[[],[],[],[],[],[],"","",[],["","","","","",""]];
}else{
	getUnitLoadout _player;
};
["loadout",_loadout, _uid] call fn_savePlayerData;