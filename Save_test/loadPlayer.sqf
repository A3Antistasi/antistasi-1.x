params ["_player"];

_uid = getPlayerUID _player

_saveArray = saveObj getVariable _uid;

if(isNil "_saveArray")exitWith{
	//new player

	//remove gear?
};

{
	_x call{
		params ["_name","_data"];

		if(_name = "_loadout")exitWith{
			_player setUnitLoadout _data;
		};
		if(_name = "_rank")exitWith{
			_player setRank _data;
		};
		if()exitWith{};
		if()exitWith{};
	};
}forEach _saveArray;

_player setUnitLoadout _loadout;

