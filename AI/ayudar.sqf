private ["_unit","_medico","_timeOut","_curado"];
_unit = _this select 0;
_medico = _this select 1;

_curado = false;

if (_medico != _unit) then
	{
	if ((not (_unit getVariable "inconsciente")) and (not(_unit getVariable ["ayudado",false]))) then
		{
		_unit setVariable ["ayudado",true];
		_medico setVariable ["ayudando",true];
		_unit groupChat format ["Comrades, this is %1. I'm hurt",name _unit];
		playSound3D [(injuredSounds call BIS_fnc_selectRandom),_unit,false, getPosASL _unit, 1, 1, 50];
		sleep 2;
		_medico groupChat format ["Wait a minute comrade %1, I will patch you up",name _unit];
		}
	else
		{
		_unit setVariable ["ayudado",true];
		_medico setVariable ["ayudando",true];
		};
	if (player == _unit) then {hint format ["%1 is on the way to help you",name _medico]};
	[_medico,_unit] call cubrirConHumo;
	_medico stop false;
	_timeOut = time + 60;
	_medico disableAI "AUTOCOMBAT";
	while {true} do
		{
		_medico doMove getPosATL _unit;
		if ((!alive _medico) or (!alive _unit) or (_medico distance _unit < 3) or (_timeOut < time) or (_medico getVariable "inconsciente") or (_unit != vehicle _unit) or (_medico != vehicle _medico)) exitWith {};
		if (isPlayer _unit) then
			{
			if ((unitReady _medico) and (alive _medico) and (_medico distance _unit > 3) and (!(_medico getVariable "inconsciente"))) then {_medico setPos position _unit};
			};
		sleep 1;
		};
	_medico enableAI "AUTOCOMBAT";
	if ((_unit distance _medico < 3) and (alive _unit) and (alive _medico)) then
		{
		_medico stop true;
		_unit stop true;
		_medico action ["HealSoldier",_unit];
		if (activeACEMedical) then {
			_medico playMove "AinvPknlMstpSnonWnonDnon_medic_1";
		};
		sleep 10;
		if (activeACEMedical) then {
			[_unit, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
		};
		_medico stop false;
		_unit stop false;
		_unit dofollow leader group _unit;
		_medico doFollow leader group _unit;
		_curado = true;
		if ((alive _medico) and (alive _unit) /*and (not(_unit getVariable "inconsciente"))*/ and (not(_medico getVariable "inconsciente"))) then
			{
			if (_medico != _unit) then {_medico groupChat format ["You are ready %1",name _unit]};
			};
		};
	_unit setVariable ["ayudado",nil];
	_medico setVariable ["ayudando",nil];
	}
else
	{
	[_medico,_medico] call cubrirConHumo;
	_unit setVariable ["ayudado",true];
	_medico setVariable ["ayudando",true];
	_medico action ["HealSoldierSelf",_medico];
	if (activeACEMedical) then {
		_medico playMove "AinvPknlMstpSnonWnonDnon_medic_1";
	};
	sleep 10;
	if (activeACEMedical) then {
		[_unit, _unit] call ace_medical_fnc_treatmentAdvanced_fullHeal;
	};
	_unit setVariable ["ayudado",nil];
	_medico setVariable ["ayudando",nil];
	_curado = true;
	};
_curado