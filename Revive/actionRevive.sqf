_curado = _this select 0;
_curandero = _this select 1;

if (not("FirstAidKit" in (items _curandero))) exitWith {hint "You need a First Aid Kit to be able to revive"};

_curandero action ["HealSoldier",_curado];