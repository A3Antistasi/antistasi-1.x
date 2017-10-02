private ["_display","_childControl","_coste","_costeHR","_unidades","_formato"];
if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};
createDialog "squad_recruit";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 104;
	_coste = 0;
	_costeHR = 0;
	_tipogrupo = guer_grp_squad;
	_formato = ([guer_grp_squad, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _costeHR = _costeHR +1} forEach _tipogrupo;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 105;
	_coste = 0;
	_costeHR = 0;
	_tipogrupo = guer_grp_team;
	_formato = ([guer_grp_team, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _costeHR = _costeHR +1} forEach _tipogrupo;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 106;
	_coste = 0;
	_costeHR = 0;
	_tipogrupo = guer_grp_AT;
	_formato = ([guer_grp_AT, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _costeHR = _costeHR +1} forEach _tipogrupo;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 107;
	_coste = 0;
	_costeHR = 0;
	_tipogrupo = guer_grp_sniper;
	_formato = ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _costeHR = _costeHR +1} forEach _tipogrupo;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 108;
	_coste = 0;
	_costeHR = 0;
	_tipogrupo = guer_grp_sentry;
	_formato = ([guer_grp_sentry, "guer"] call AS_fnc_pickGroup);
	if !(typeName _tipogrupo == "ARRAY") then {
		_tipogrupo = [_formato] call groupComposition;
	};
	{_coste = _coste + (server getVariable _x); _costeHR = _costeHR +1} forEach _tipogrupo;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];


	_ChildControl = _display displayCtrl 109;
	_coste = (2*(server getVariable guer_sol_R_L));
	_costeHR = 2;
	_coste = _coste + ([guer_veh_truck] call vehiclePrice) + ([guer_stat_AT] call vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 110;
	_coste = (2*(server getVariable guer_sol_R_L));
	_costeHR = 2;
	_coste = _coste + ([guer_veh_truck] call vehiclePrice) + ([guer_stat_AA] call vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];

	_ChildControl = _display displayCtrl 111;
	_coste = (2*(server getVariable guer_sol_R_L));
	_costeHR = 2;
	_coste = _coste + ([guer_veh_truck] call vehiclePrice) + ([guer_stat_mortar] call vehiclePrice);
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €. HR: %2",_coste,_costeHR];
};