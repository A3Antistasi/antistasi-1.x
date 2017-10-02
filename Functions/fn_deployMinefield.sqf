params ["_type", "_number", "_radius", ["_sides", [side_green, side_red]], ["_silent", true]];
private ["_minePos", "_mine"];

if ((_number < 1) || (_radius < 1)) exitWith {};

finPos = [];

openMap true;
onMapSingleClick "finPos = _pos;";

waitUntil {sleep 1; (count finPos > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_minePos =+ finPos;
openMap false;

if (surfaceIsWater _minePos) exitWith {hint "Restriced to land usage."};

for "_i" from 1 to _number do {
	_mine = createMine [_type, _minePos, [], _radius];
	{
		_x revealMine _mine;
	} forEach _sides;
};

finPos = nil;

if !(_silent) then {hintSilent ["Minefield deployed: %1x %2 at %3", _number, _type, _minePos]};