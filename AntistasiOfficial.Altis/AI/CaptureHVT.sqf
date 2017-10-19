_mayor = _this select 0;
_capturer = _this select 1;

[[_mayor,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
//removeAllActions _unit;

_mayor = _this select 0;
_mayor globalChat "Ok I surrender!";
_mayor setcaptive 1;
_mayor disableAI "MOVE";
sleep 5;
_mayor globalChat "I will follow your commands, but if your enemy see me they will kill me.";
sleep 5;
_mayor disableAI "AUTOTARGET";
_mayor setCaptive 0;
_mayor enableAI "MOVE";
_capturer = _this select 1;
[_mayor] joinSilent _capturer;

//Will add strings to stringtable when adding the mission to the selection script.