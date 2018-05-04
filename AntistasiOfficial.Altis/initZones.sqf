private ["_allMarkers","_sizeX","_sizeY","_size","_name","_pos","_roads","_numCiv","_roadsProv","_roadcon", "_supplyLevelFood", "_supplyLevelWater", "_supplyLevelFuel", "_numVeh","_nroads","_nearRoadsFinalSorted","_mrk","_dmrk","_info","_antennaArray","_antenna","_bankArray","_bank","_blackList"];

AS_destroyedZones = [];
forcedSpawn = [];
ciudades = [];
colinas = [];
colinasAA = [];
power = [];
bases = [];
aeropuertos = [];
recursos = [];
fabricas = [];
puestos = [];
puestosAA = [];
puertos = [];
controles = [];
artyEmplacements = [];
seaMarkers = [];
puestosFIA = [];
puestosNATO = [];
campsFIA = [];
mrkAAF = [];
destroyedCities = [];
posAntenas = [];
antenas = [];
mrkAntenas = [];
bancos = [];
posbancos = [];
supplySaveArray = [];
safeDistance_undercover = 350;
safeDistance_garage = 500;
safeDistance_recruit = 500;
safeDistance_garrison = 500;
safeDistance_fasttravel = 500;

// Blacklist of locations not be used as towns
_blackList = ["Giswil","sagonisi","hill12"];

call {
    if (worldName == "Altis") exitWith {
        call compile preprocessFileLineNumbers "Worlds\AltisData.sqf";
    };
    if ((worldName == "Napf") OR (worldName == "NapfWinter")) exitWith {
        call compile preprocessFileLineNumbers "Worlds\NapfData.sqf";
    };
    if (worldName == "Tanoa") exitWith {
        call compile preprocessFileLineNumbers "Worlds\TanoaData.sqf";
    };
    if (worldName == "Bornholm") exitWith {
        call compile preprocessFileLineNumbers "Worlds\BornholmData.sqf";
    };
	if (worldName == "xcam_taunus") exitWith {
        call compile preprocessFileLineNumbers "Worlds\xcam_taunusData.sqf";
    };
};

// Search the markers placed within the SQM for each type and create corresponding lists. A pre-defined list is available for Altis.
if !(count controles > 0) then {
    _allMarkers = allMapMarkers;
    {
        call {
            if (toLower _x find "control" >= 0) exitWith {controles pushBackUnique _x};
            if (toLower _x find "puestoAA" >= 0) exitWith {puestosAA pushBackUnique _x};
            if (toLower _x find "puesto" >= 0) exitWith {puestos pushBackUnique _x};
            if (toLower _x find "seaPatrol" >= 0) exitWith {seaMarkers pushBackUnique _x};
            if (toLower _x find "base" >= 0) exitWith {bases pushBackUnique _x};
            if (toLower _x find "power" >= 0) exitWith {power pushBackUnique _x};
            if (toLower _x find "airport" >= 0) exitWith {aeropuertos pushBackUnique _x};
            if (toLower _x find "resource" >= 0) exitWith {recursos pushBackUnique _x};
            if (toLower _x find "factory" >= 0) exitWith {fabricas pushBackUnique _x};
            if (toLower _x find "artillery" >= 0) exitWith {artyEmplacements pushBackUnique _x};
            if (toLower _x find "mtn_comp" >= 0) exitWith {colinasAA pushBackUnique _x};
            if (toLower _x find "mtn" >= 0) exitWith {colinas pushBackUnique _x};
            if (toLower _x find "puerto" >= 0) exitWith {puertos pushBackUnique _x};
        };
    } forEach _allMarkers;

    puestos = puestos + puestosAA;
    puestos = puestos arrayIntersect puestos;
};

mrkFIA = ["FIA_HQ"];
garrison setVariable ["FIA_HQ",[],true];
markers = power + bases + aeropuertos + recursos + fabricas + puestos + puertos + controles + colinas + colinasAA + puestosAA + ["FIA_HQ"];

// Make sure all markers are invisible and not currently marked as having been spawned in.
{_x setMarkerAlpha 0;
    spawner setVariable [_x,false,true];
} forEach (markers + artyEmplacements);
{_x setMarkerAlpha 0} forEach seaMarkers;

// Detect cities, set their population to the number of houses within their city limits, create a database of roads, set number of civilian vehicles to spawn with regards to number of roads. Pre-defined for Altis.
{
    _name = [text _x, true] call AS_fnc_location;
    if ((_name != "") and !(_name in _blackList)) then {
        _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
        _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
        _size = [_sizeX, _sizeY] select (_sizeX < _sizeY);
        if (_size < 200) then {_size = 200};

        _pos = getPos _x;
        _roads = [];
        _numCiv = 0;
        if (worldName != "Altis") then {
            _numCiv = (count (nearestObjects [_pos, ["house"], _size]));
            _roadsProv = _pos nearRoads _size;
            {
                _roadcon = roadsConnectedto _x;
                if (count _roadcon == 2) then {
                    _roads pushBack (getPosATL _x);
                };
            } forEach _roadsProv;
            carreteras setVariable [_name,_roads];
        } else {
            _roads = carreteras getVariable _name;
            _numCiv = server getVariable _name;
            if (isNil "_numCiv") then {hint format ["Error in initZones.sqf -- population not set for: %1",_name]};
            if (typeName _numCiv != typeName 0) then {hint format ["Error in initZones.sqf -- wrong datatype for population. City: %1; datatype: %2",_name, typeName _numCiv]};
        };

        _numVeh = round (_numCiv / 3);
        _nroads = count _roads;
        _nearRoadsFinalSorted = [_roads, [], { _pos distance _x }, "ASCEND"] call BIS_fnc_sortBy;
		if (count _nearRoadsFinalSorted > 0) then {_pos = _nearRoadsFinalSorted select 0};
        _mrk = createmarker [format ["%1", _name], _pos];
        _mrk setMarkerSize [_size, _size];
        _mrk setMarkerShape "RECTANGLE";
        _mrk setMarkerBrush "SOLID";
        _mrk setMarkerColor IND_marker_colour;
        _mrk setMarkerText _name;
        _mrk setMarkerAlpha 0;
        ciudades pushBack _name;
        spawner setVariable [_name,false,true];
        _dmrk = createMarker [format ["Dum%1",_name], _pos];
        _dmrk setMarkerShape "ICON";
        _dmrk setMarkerType "loc_Cross";
        _dmrk setMarkerColor IND_marker_colour;

		_supplyLevelFood = 'LOW';
		_supplyLevelWater = 'LOW';
		_supplyLevelFuel = 'LOW';

        if (_nroads < _numVeh) then {_numVeh = _nroads};
        _info = [_numCiv, _numVeh, prestigeOPFOR,prestigeBLUFOR, [_supplyLevelFood, _supplyLevelWater, _supplyLevelFuel]];
        server setVariable [_name,_info,true];
    };
} foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCityCapital","NameCity","NameVillage","CityCenter"], worldSize/1.414]);

// Detect named mountaintops and automatically add them as zones to spawn a watchpost at. If your map has a shortage of named mountains, place markers within the SQM, with incremental names starting with "mtn_1" for automatic watchpost placement or "mtn_comp_1" for positions with pre-defined compositions.
{
    _name = text _x;
    if ((_name != "Magos") AND !(_name == "")) then {
        _sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusA");
        _sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> (text _x) >> "radiusB");
        if (_sizeX > _sizeY) then {_size = _sizeX} else {_size = _sizeY};
        _pos = getPos _x;
        if (_size < 10) then {_size = 50};

        _mrk = createmarker [format ["%1", _name], _pos];
        _mrk setMarkerSize [_size, _size];
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "SOLID";
        _mrk setMarkerColor "ColorRed";
        _mrk setMarkerText _name;
        colinas pushBack _name;
        spawner setVariable [_name,false,true];
        _mrk setMarkerAlpha 0;
    };
} foreach (nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["Hill"], worldSize/1.414]);

markers = markers + colinas + ciudades;

planesAAFmax = count aeropuertos;
helisAAFmax = 2* (count aeropuertos);
tanksAAFmax = count bases;
APCAAFmax = 2* (count bases);


_fnc_marker = {};
if (worldName in ["Altis", "altis", "Bornholm", "bornholm", "Tanoa", "tanoa", "Napf", "napf"]) then {
    _fnc_marker = {
        params ["_loc", "_type", "_text"];

        _pos = getMarkerPos _loc;
        _dmrk = createMarker [format ["Dum%1",_loc], _pos];
        _dmrk setMarkerShape "ICON";
        _dmrk setMarkerColor IND_marker_colour;
        garrison setVariable [_loc,[],true];
        _dmrk setMarkerType _type;
        _dmrk setMarkerText _text;
    };
} else {
    _fnc_marker = {
        params ["_loc", "_type", "_text"];

        _pos = getMarkerPos _loc;
        _dmrk = createMarker [format ["Dum%1",_loc], _pos];
        _dmrk setMarkerShape "ICON";
        if !(_loc in (aeropuertos+bases)) then {_dmrk setMarkerColor IND_marker_colour};
        [_loc] call AS_fnc_createRoadblocks;
        garrison setVariable [_loc,[],true];
        _dmrk setMarkerType _type;
        _dmrk setMarkerText _text;
    };
};

{
    [_x, "loc_power", localize "STR_GL_MAP_PP"] call _fnc_marker;
} forEach power;

{
    [_x, IND_marker_type, format [localize "STR_GL_MAP_AP", A3_Str_INDEP]] call _fnc_marker;
    server setVariable [_x,dateToNumber date,true];
} forEach aeropuertos;

{
    [_x, IND_marker_type, format [localize "STR_GL_MAP_MB", A3_Str_INDEP]] call _fnc_marker;
    server setVariable [_x,dateToNumber date,true];
} forEach bases;

{
    [_x, "loc_rock", localize "STR_GL_MAP_RS"] call _fnc_marker;
} forEach recursos;

{
    [_x, "u_installation", localize "STR_GL_MAP_FAC"] call _fnc_marker;
} forEach fabricas;

{
    [_x, "loc_bunker", format [localize "STR_GL_MAP_AA", A3_Str_INDEP]] call _fnc_marker;
} forEach puestosAA;

{
    [_x, "loc_bunker", format [localize "STR_GL_MAP_OP", A3_Str_INDEP]] call _fnc_marker;
} forEach puestos;

{
    [_x, "b_naval", localize "STR_GL_MAP_SP"] call _fnc_marker;
} forEach puertos;

markers = markers arrayIntersect markers;
mrkAAF = markers - ["FIA_HQ"];
publicVariable "mrkAAF";
publicVariable "mrkFIA";
publicVariable "markers";
publicVariable "ciudades";
publicVariable "colinas";
publicVariable "colinasAA";
publicVariable "power";
publicVariable "bases";
publicVariable "aeropuertos";
publicVariable "recursos";
publicVariable "fabricas";
publicVariable "puestos";
publicVariable "puestosAA";
publicVariable "controles";
publicVariable "puertos";
publicVariable "destroyedCities";
publicVariable "forcedSpawn";
publicVariable "puestosFIA";
publicVariable "seaMarkers";
publicVariable "campsFIA";
publicVariable "puestosNATO";
publicVariable "supplySaveArray";
publicVariable "safeDistance_undercover";
publicVariable "safeDistance_garage";
publicVariable "safeDistance_recruit";
publicVariable "safeDistance_garrison";
publicVariable "safeDistance_fasttravel";

"spawnCSAT" setMarkerType OPFOR_marker_type;
"spawnCSAT" setMarkerText format [localize "STR_GL_MAP_CRR", A3_Str_RED];
"spawnNATO" setMarkerType BLUFOR_marker_type;
"spawnNATO" setMarkerText format [localize "STR_GL_MAP_CRR", A3_Str_BLUE];

if (count posAntenas > 0) then {
    for "_i" from 0 to (count posantenas - 1) do {
        _antennaArray = nearestObjects [posantenas select _i,["Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F"], 25];
        if (count _antennaArray > 0) then {
            _antenna = _antennaArray select 0;
            antenas = antenas + [_antenna];
            _mrkfin = createMarker [format ["Ant%1", _i], posantenas select _i];
            _mrkfin setMarkerShape "ICON";
            _mrkfin setMarkerType "loc_Transmitter";
            _mrkfin setMarkerColor "ColorBlack";
            _mrkfin setMarkerText localize "STR_GL_MAP_RT";
            mrkAntenas = mrkAntenas + [_mrkfin];
            _antenna addEventHandler ["Killed", {
                _antenna = _this select 0;
                _mrk = [mrkAntenas, _antenna] call BIS_fnc_nearestPosition;
                antenas = antenas - [_antenna]; antenasmuertas = antenasmuertas + [getPos _antenna]; deleteMarker _mrk;
                if (activeBE) then {["cl_loc"] remoteExec ["fnc_BE_XP", 2]};
                {["TaskSucceeded", ["", localize "STR_TSK_TD_RADIO_DESTROYED"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
            }];
        };
    };
};

publicVariable "antenas";
antenasmuertas = [];

if (count posbancos > 0) then {
	for "_i" from 0 to (count posbancos - 1) do {
		_bankArray = nearestObjects [posbancos select _i,["Land_Offices_01_V1_F"], 25];
		if (count _bankArray > 0) then {
			_bank = _bankArray select 0;
			bancos = bancos + [_bank];
		};
	};
};

//the following is the console code snippet I use to pick positions of any kind of building. You may do this for gas stations, banks, radios etc.. markerPos "Base_4" is because it's in the middle of the island, and inside the array you may find the type of building I am searching for. Paste the result in a txt and add it to the corresponding arrays.
/*
pepe = nearestObjects [markerPos "base_4", ["Land_Offices_01_V1_F"], 16000];
pospepe = [];
{pospepe = pospepe + getPos _x} forEach pepe;
copytoclipboard str pospepe;
*/
if (isMultiplayer) then {[[petros,"locHint","STR_INFO_INITZONES"],"commsMP"] call BIS_fnc_MP;}
