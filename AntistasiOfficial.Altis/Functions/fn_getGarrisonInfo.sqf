params ["_location"];
private ["_text","_garrison","_size","_position"];

_garrison = garrison getVariable [_location,[]];
_size = [_location] call sizeMarker;
_position = getMarkerPos _location;

format ["\n
	\nGarrison men: %1
	\n\nSquad Leaders: %2
	\nMortars: %3
	\nRiflemen: %4
	\nAutoriflemen: %5
	\nMedics: %6
	\nGrenadiers: %7
	\nMarksmen: %8
	\nAT Men: %9
	\nStatic Weap: %10",
	count _garrison,
	{_x == guer_sol_SL} count _garrison,
	{_x == guer_sol_UN} count _garrison,
	{_x == guer_sol_RFL} count _garrison,
	{_x == guer_sol_AR} count _garrison,
	{_x == guer_sol_MED} count _garrison,
	{_x == guer_sol_GL} count _garrison,
	{_x == guer_sol_MRK} count _garrison,
	{_x == guer_sol_LAT} count _garrison,
	{_x distance _position < _size} count staticsToSave
]