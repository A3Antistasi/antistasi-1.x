params ["_unit"];
private ["_rank", "_abbreviation", "_idRank","_nextRank","_result"];

_rank = _unit getVariable ["rango","PRIVATE"];
_abbreviation = "CPL";
switch (_rank) do {
	case "PRIVATE": {_idRank= 1; _nextRank = "CORPORAL"; _abbreviation = "CPL"};
	case "CORPORAL": {_idRank = 2; _nextRank = "SERGEANT"; _abbreviation = "SGT"};
	case "SERGEANT": {_idRank = 3; _nextRank = "LIEUTENANT"; _abbreviation = "LT"};
	case "LIEUTENANT": {_idRank = 4; _nextRank = "CAPTAIN"; _abbreviation = "CPT"};
	case "CAPTAIN": {_idRank = 5; _nextRank = "MAJOR"; _abbreviation = "MAJ"};
	case "MAJOR": {_idRank = 6; _nextRank = "COLONEL"; _abbreviation = "COL"};
	case "COLONEL": {_idRank = 7; _nextRank = "COLONEL"; _abbreviation = "COL"};
};

[_idRank, _nextRank, _abbreviation]