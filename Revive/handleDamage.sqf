private ["_unit","_part","_dam","_injurer"];
_unit = _this select 0;
_part = _this select 1;
_dam = _this select 2;
_injurer = _this select 3;

//faltará todos los checks de petros, y de castigo, en Slowhand init habrá que esperar a que no esté inconsciente, también los checks de owner
//Check on Remote Control
if (isPlayer _unit) then
	{
	_owner = player getVariable ["owner",player];
	if (_owner!=player) then
		{
		if ((isNull _injurer) and (_unit distance fuego < 10)) then
			{
			_dam = 0;
			}
		else
			{
			removeAllActions _unit;
			selectPlayer _owner;
			_unit setVariable ["owner",_owner,true];
			{[_x] joinsilent group player} forEach units group player;
			group player selectLeader player;
			hint "Returned to original Unit as controlled AI received damage";
			};
		};
	}
else
	{
	if (local _unit) then
		{
		_owner = _unit getVariable "owner";
		if (!isNil "_owner") then
			{
			if (_owner==_unit) then
				{
				if ((isNull _injurer) and (_unit distance fuego < 10)) then
					{
					_dam = 0;
					}
				else
					{
					removeAllActions player;
					selectPlayer _owner;
					{[_x] joinsilent group player} forEach units group player;
					group player selectLeader player;
					hint "Returned to original Unit as it received damage";
					};
				};
			};
		};
	};

if (_part == "") then
	{
	if (_dam >= 1) then    //Stef 16/10 disable instadeath
		{
		if (!(_unit getVariable "inconsciente")) then
			{
			moveOut _unit;
			_dam = 0.9;
			[_unit] spawn inconsciente;
			}
		else
			{
			if (isPlayer _unit) then
				{
				_dam = 0;
				[_unit] spawn respawn;
				if (isPlayer _injurer) then
					{
					if (_injurer != _unit) then {[_injurer,60] remoteExec ["AS_fnc_punishPlayer", _injurer]};
					};
				}
			else
				{
				_unit removeAllEventHandlers "HandleDamage";
				};
			};
		}
	else
		{
		if (_dam > 0.25) then
			{
			if (isPlayer (leader group _unit)) then
				{
				if (autoheal) then
					{
					_ayudado = _unit getVariable "ayudado";
					if (isNil "_ayudado") then {[_unit] call pedirAyuda;};
					};
				}
			else
				{
				if (_dam > 0.6) then {[_unit,_unit] spawn cubrirConHumo};
				};
			};
		};
	}
else
	{
	if (_dam > 0.95) then
		{
		if (_part == "head") then
			{
			removeHeadgear _unit;
			};
		_dam = 0.9;
		};
	};
_dam