//if (activeACE) exitWith {hint "Feature disabled with ACE Mod"};
if (player != Slowhand) exitWith {hint "Only Commander has the ability to control HC units"};
if ({((side _x == side_green) or (side _x == side_red)) and (not (captive _x)) and (_x distance player < 500)} count allUnits > 0) exitWith {hint "You cannot remote control with enemies nearby"};

_grupos = _this select 0;

_grupo = _grupos select 0;
_unit = leader _grupo;

if (_unit getVariable ["inconsciente",false]) exitWith {hint "You cannot control an unconscious unit"};
if (!alive _unit) exitWith {hint "You cannot control a dead unit"};
if ((not(typeOf _unit in guer_soldierArray)) and (typeOf _unit != guer_POW)) exitWith {hint "You cannot control a unit which does not belong to FIA"};

while {(count (waypoints _grupo)) > 0} do
 {
  deleteWaypoint ((waypoints _grupo) select 0);
 };

_wp = _grupo addwaypoint [getpos _unit,0];

{
if (_x != vehicle _x) then
	{
	[_x] orderGetIn true;
	};
} forEach units group player;

hcShowBar false;
hcShowBar true;

_unit setVariable ["owner",player,true];
selectPlayer _unit;
(_unit getVariable ["owner",_unit]) allowDamage false;

_tiempo = 60;

_unit addAction [localize "Str_act_returnControl",{selectPlayer (player getVariable ["owner",player])}];
_break = false;
_testEH = _unit addEventHandler ["HandleDamage", {
	_unit = _this select 0;
	_part = _this select 1;
	_damage = _this select 2;
	_source = _this select 3;
	_projectile = _this select 4;
	if (_damage > 0.05) then {_break = true};
	_damage
}];

waitUntil {sleep 1; hint format ["Time to return control to AI: %1", _tiempo]; _tiempo = _tiempo - 1; (_tiempo < 0) or (isPlayer Slowhand) || (_break)};

removeAllActions _unit;
_unit removeEventHandler ["HandleDamage", _testEH];
if (!isPlayer (_unit getVariable ["owner",_unit])) then {selectPlayer (_unit getVariable ["owner",_unit])};
//_unit setVariable ["owner",nil,true];

{[_x] joinsilent group Slowhand} forEach units group Slowhand;
group Slowhand selectLeader Slowhand;
Slowhand allowDamage true;
hint "";