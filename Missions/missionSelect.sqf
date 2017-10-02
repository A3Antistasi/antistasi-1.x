params ["_optionsPamphlet","_optionsBrainwash"];
["none","none","none"] params ["_textP","_textBW","_city"];

if (count _optionsPamphlet > 0) then {
	_textP = _optionsPamphlet select 0;
};
if (count _optionsPamphlet > 1) then {
	for "_i" from 1 to ((count _optionsPamphlet) - 1) do {
		_textP = _textP + ", ";
		_textP = _textP + (_optionsPamphlet select _i);
	};
};

if (count _optionsBrainwash > 0) then {
	_textBW = _optionsBrainwash select 0;
};
if (count _optionsBrainwash > 1) then {
	for "_i" from 1 to ((count _optionsBrainwash) - 1) do {
		_textBW = _textBW + ", ";
		_textBW = _textBW + (_optionsBrainwash select _i);
	};
};

hint format ["Cities available for a Leaflet Drop: %1 \n\nCities available for a broadcast: %2",_textP,_textBW];

temp_position = [];

openMap true;
onMapSingleClick "temp_position = _pos;";

waitUntil {sleep 1; (count temp_position > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {openMap false; hint "No mission for you, mate!";};

_city = [ciudades, temp_position] call BIS_Fnc_nearestPosition;

if !((_city in _optionsPamphlet) OR (_city in _optionsBrainwash)) exitWith {openMap false; hint "No mission for you, mate!";};

if (_city in _optionsBrainwash) then {
	[_city] remoteExec ["PR_Brainwash",HCgarrisons];
} else {
	[_city] remoteExec ["PR_Pamphlet",HCgarrisons];
};
openMap false;
temp_position = nil;