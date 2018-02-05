//to be spawned by \Create\CSATpunish.sqf

sleep 900; //15 min, can be balanced
{(_this select 1) reveal _x} foreach (_this select 0);
diag_log format ["CSATPUNISH: CSAT = %1, CIVI = %2",_this select 1,_this select 0];