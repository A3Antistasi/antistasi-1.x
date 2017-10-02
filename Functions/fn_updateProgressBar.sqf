params [["_type", "Rank"], ["_parameters", [], []]];
private ["_colour", "_PBar", "_p", "_varName", "_value"];

_p = [];
_varName = "";
_PBar = "";

_colour = "#1DA81D";
_colourDef = "#C1C0BB";

if (_type == "Rank") then {
	private ["_current", "_rankData", "_multiplier", "_needed", "_nextRank"];

	if (player getVariable ["rango","PRIVATE"] == "COLONEL") exitWith {player setVariable ["Rank_PBar", "COLONEL", true]};
	_current = player getVariable ["score",0];
	_rankData = [player] call AS_fnc_getRank;
	_multiplier = _rankData select 0;
	_needed = 50*_multiplier;
	_nextRank = _rankData select 2;

	_value = (_current / _needed) max 0;
	_p = [_colour, _colourDef, player getVariable ["rango","PRIVATE"], _nextRank, _type];
	_varName = "Rank_PBar";
};

if (count _parameters > 0) then {
	_p = _parameters select 0;
	_value = _parameters select 1;
	_varName = _parameters select 2;
};

call {
	if (_value > 0.80) exitWith {
		_PBar = format (["%5: %3 (<t color='%1'>>>>></t><t color='%2'></t>%4)"] + _p);
	};
	if (_value > 0.60) exitWith {
		_PBar = format (["%5: %3 (<t color='%1'>>>></t><t color='%2'>></t>%4)"] + _p);
	};
	if (_value > 0.40) exitWith {
		_PBar = format (["%5: %3 (<t color='%1'>>></t><t color='%2'>>></t>%4)"] + _p);
	};
	if (_value > 0.20) exitWith {
		_PBar = format (["%5: %3 (<t color='%1'>></t><t color='%2'>>>></t>%4)"] + _p);
	};
	if (_value <= 0.20) exitWith {
		_PBar = format (["%5: %3 (<t color='%2'>>>>></t>%4)"] + _p);
	};
};

if (_type == "Rank") exitWith {
	player setVariable [_varName, _PBar, true];
};

if (_type == "Army XP") exitWith {
	server setVariable [_varName, _PBar, true];
};