params [["_ignoreDistance", false]]; //Use true to ignore the distance checks. Sparker.

if(((petros distance caja) > 30 || (petros distance cajaVeh) > 30) && !_ignoreDistance) exitWith {hint "Move the ammoboxes closer to Petros.";};
if(((!isNull (attachedTo caja)) || !(isNull (attachedTo cajaVeh))) && !_ignoreDistance) exitWith {hint "You need to unload both ammoboxes first.";};
//Remove actions to load the boxes with Jeroen's script
caja call jn_fnc_logistics_removeAction;
cajaVeh call jn_fnc_logistics_removeAction;

private ["_pos","_rnd"];
_movido = false;
if (group petros != grupoPetros) then
	{
	_movido = true;
	[petros] join grupoPetros;
	};
[[petros,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
petros forceSpeed 0;
guer_respawn setMarkerPos getPos petros;
"FIA_HQ" setMarkerPos getPos petros;
posHQ = getMarkerPos guer_respawn; publicVariable "posHQ";
server setVariable ["posHQ", getMarkerPos guer_respawn, true];

if (isMultiplayer) then
	{
	caja hideObjectGlobal false;
	cajaVeh hideObjectGlobal false;
	mapa hideObjectGlobal false;
	fuego hideObjectGlobal false;
	bandera hideObjectGlobal false;
	}
else
	{
	if (_movido) then {hint "Please wait while moving HQ Assets to selected position"};
	//sleep 5
	caja hideObject false;
	cajaVeh hideObject false;
	mapa hideObject false;
	fuego hideObject false;
	bandera hideObject false;
	};
fuego inflame true;
guer_respawn setMarkerAlpha 1;
_pos = [getPos petros, 3, getDir petros] call BIS_Fnc_relPos;
fuego setPos _pos;
_rnd = getdir Petros;
if (isMultiplayer) then {sleep 5};
_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
if(_ignoreDistance) then
{
	caja setPos _pos; //Set it up for Jeroen's cargo loading script. Sparker.
};
_rnd = _rnd + 45;
_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
mapa setPos _pos;
mapa setDir ([fuego, mapa] call BIS_fnc_dirTo);
_rnd = _rnd + 45;
_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
bandera setPos _pos;
_rnd = _rnd + 45;
_pos = [getPos fuego, 3, _rnd] call BIS_Fnc_relPos;
if(_ignoreDistance) then
{
	cajaVeh setPos _pos;
};
if (_movido) then {[] call vaciar};
placementDone = true; publicVariable "placementDone";
sleep 5;
[[Petros,"mission"],"AS_fnc_addActionMP"] call BIS_fnc_MP;


//Stef Check if road is found within 500m
_arr1 = [(getMarkerPos guer_respawn), [ciudades, (getMarkerPos guer_respawn)] call BIS_fnc_nearestPosition] call AS_fnc_findRoadspot;
if(_arr1 isequalto []) then {hint localize "STR_HINTS_COMMANDER_HQBUILDFAR"; petros globalChat localize "STR_HINTS_COMMANDER_HQBUILDFAR"; petros globalChat localize "STR_HINTS_HQFAR_BUILD"};

//[] remoteExec ["petrosAnimation", 2];