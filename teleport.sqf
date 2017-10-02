// for easier testing

openMap true;
posicionTel = [];
hint "Click on the position you wish to teleport to.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;
_pos = [];

if (player != vehicle player) then {
	_pos = _posicionTel findEmptyPosition [1,50,typeOf (vehicle player)];
	vehicle player setPosATL _pos;
} else {
	_pGroup = group player;
	{
		_unit = _x;
		_unit allowDamage false;
		_unit setPosATL _posicionTel;
	} forEach units _pGroup;
};

openMap false;