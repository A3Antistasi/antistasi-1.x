if (!isServer and hasInterface) exitWith {};

private ["_tipo","_posbase","_posibles","_sitios","_exists","_sitio","_pos","_ciudad"];

_tipo = _this select 0;

_posbase = getMarkerPos guer_respawn;
_posibles = [];
_sitios = [];
_exists = false;

_excl = [posNomad];

_fnc_info = {
	params ["_text", ["_hint", "none"]];
	{
		[[["Nomad", _text]],"DIRECT",0.15] remoteExec ["createConv",_x];
		if !(_hint == "none") then {[_hint] remoteExec ["hint",_x];}
	} forEach ([15,0,position Nomad,"BLUFORSpawn"] call distanceUnits);
};

_silencio = false;
if (count _this > 1) then {_silencio = true};

if (_tipo in misiones) exitWith {
	if (!_silencio) then {
		["I already gave you a mission of this type."] call _fnc_info;
	};
};

if ((server getVariable "milActive") > 1) exitWith {
	if (!_silencio) then {
		["How about you prove yourself first by doing what I told you to do..."] call _fnc_info;
	};
};

if (_tipo == "AS") then {
	_sitios = bases + ciudades - mrkFIA;
	if (count _sitios > 0) then {
		for "_i" from 0 to ((count _sitios) - 1) do {
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 4500) and (not(spawner getVariable _sitio))) then {_posibles = _posibles + [_sitio]};
		};
	};
	if (_posibles isEqualTo []) then {
		if (!_silencio) then {
			["I have no assassination missions for you. Move our HQ closer to the enemy or finish some other assassination missions in order to have better intel.", "Assasination Missions require AAF cities, Observation Posts or bases closer than 4Km from your HQ."] call _fnc_info;
		};
	}
	else {
		_ran = ((floor random 10) < 3);
		if ((count (_posibles arrayIntersect bases) > 0) && _ran) exitWith {[selectRandom (_posibles arrayIntersect bases), "mil"] remoteExec ["AS_Oficial", call AS_fnc_getNextWorker]};
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in ciudades) then {[_sitio, "mil"] remoteExec ["AS_specOP", call AS_fnc_getNextWorker];};
		if (_sitio in bases) then {[_sitio, "mil"] remoteExec ["AS_Oficial", call AS_fnc_getNextWorker];};
	};
};
/*if (_tipo == "CON") then {
	_sitios = colinasAA - mrkFIA - _excl;
	if (count _sitios > 0) then {
		for "_i" from 0 to ((count _sitios) - 1) do {
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			if ((_pos distance _posbase < 4000) and (_sitio in mrkAAF)) then {_posibles = _posibles + [_sitio]};
		};
	};
	if (_posibles isEqualTo []) then {
		if (!_silencio) then {
			["I have no Conquest missions for you. Move our HQ closer to the enemy or finish some other conquest missions in order to have better intel.", "Conquest Missions require AAF roadblocks or outposts closer than 4Km from your HQ."] call _fnc_info;
		};
	}
	else {
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in colinasAA) then {[_sitio, "mil"] remoteExec ["CON_AA", call AS_fnc_getNextWorker];};
	};
}; */  // Stef 14/09 removed conquer AA hilltop because it has no more sense.
if (_tipo == "DES") then {
	_sitios = aeropuertos + bases - mrkFIA;
	if (count _sitios > 0) then {
		for "_i" from 0 to ((count _sitios) - 1) do {
			_sitio = _sitios select _i;
			if (_sitio in markers) then {_pos = getMarkerPos _sitio} else {_pos = getPos _sitio};
			if (_pos distance _posbase < 4000) then {
				if (_sitio in markers) then {
					if (not(spawner getVariable _sitio)) then {_posibles = _posibles + [_sitio]};
				}
				else {
					_cercano = [markers, getPos _sitio] call BIS_fnc_nearestPosition;
					if (_cercano in mrkAAF) then {_posibles = _posibles + [_sitio]};
				};
			};
		};
	};
	if (_posibles isEqualTo []) then {
		if (!_silencio) then {
			["I have no destroy missions for you. Move our HQ closer to the enemy or finish some other destroy missions in order to have better intel.", "Destroy Missions require AAF bases, Radio Towers or airports closer than 4Km from your HQ."] call _fnc_info;
		};
	}
	else {
		_sitio = _posibles call BIS_fnc_selectRandom;
		if (_sitio in bases) then {[_sitio, "mil"] remoteExec ["DES_Vehicle", call AS_fnc_getNextWorker]};
		if (_sitio in aeropuertos) then {[_sitio, "mil"] remoteExec ["DES_Heli", call AS_fnc_getNextWorker]};
	};
};

if (_tipo == "CONVOY") then {
	_sitios = bases + aeropuertos - mrkFIA;
	if (count _sitios > 0) then {
		for "_i" from 0 to ((count _sitios) - 1) do {
			_sitio = _sitios select _i;
			_pos = getMarkerPos _sitio;
			_base = [_sitio] call AS_fnc_findBaseForConvoy;
			if ((_pos distance _posbase < 4000) and (_base !="")) then {
				_posibles = _posibles + [_sitio];
			};
		};
	};
	if (_posibles isEqualTo []) then {
		if (!_silencio) then {
			["I have no Convoy missions for you. Move our HQ closer to the enemy or finish some other rescue missions in order to have better intel.", "Convoy Missions require AAF Airports, Bases or Cities closer than 4Km from your HQ, and they must have an idle friendly base in their surroundings."] call _fnc_info;
		};
	}
	else {
		_sitio = _posibles call BIS_fnc_selectRandom;
		_base = [_sitio] call AS_fnc_findBaseForConvoy;
		[_sitio,_base,"mil"] remoteExec ["CONVOY", call AS_fnc_getNextWorker];
	};
};

if ((count _posibles > 0) and (!_silencio)) then {
	["I have a mission for you..."] call _fnc_info;
};
