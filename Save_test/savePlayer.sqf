#include

#define QUOTE(VAR) #VAR
QUOTE(var_1); // returns "var_1"




params ["_player"];
_uid = getPlayerUID _player
_loadout =  getUnitLoadout _player;


//items to save
_array = [_loadout,_rank];


//create list
_saveArray [];
{
	pushBack [QUOTE(_x),_x];
} forEach _array;



saveObj setVariable [_uid, _saveArray];
