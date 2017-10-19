private ["_texto","_viejoTexto","_display","_setText"];
showStatistics = false;
sleep 3;
showStatistics = true;
disableSerialization;
//1 cutRsc ["H8erHUD","PLAIN",0,false];
_layer = ["estadisticas"] call bis_fnc_rscLayer;
_layer cutRsc ["H8erHUD","PLAIN",0,false];
waitUntil {!isNull (uiNameSpace getVariable "H8erHUD")};

_display = uiNameSpace getVariable "H8erHUD";
_setText = _display displayCtrl 1001;
_setText ctrlSetBackgroundColor [0,0,0,0];
_viejoTexto = "";
if (isMultiplayer) then
	{
	private ["_nombreC"];
	while {showStatistics} do
		{
		waitUntil {sleep 0.5; player == player getVariable ["owner",player]};
		if (player != Slowhand) then
			{
			if (isPlayer Slowhand) then {_nombreC = name Slowhand} else {_nombreC = "NONE"};
			if (activeBE) then {
				_texto = format ["<t size='0.55'>" + "Commander: %3 | %2 | HR: %1 | Your Money: %4 € | %9 Support: %5 | %10 Support: %6 | %7 | %8", server getVariable "hr", player getVariable ["Rank_PBar", "Init"], _nombreC, player getVariable "dinero",server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", server getVariable "BE_PBar", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
			} else {
				_texto = format ["<t size='0.55'>" + "Commander: %3 | %2 | HR: %1 | Your Money: %4 € | %8 Support: %5 | %9 Support: %6 | %7", server getVariable "hr", player getVariable ["Rank_PBar", "Init"], _nombreC, player getVariable "dinero",server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
			};
		}
		else
			{
				if (activeBE) then {
					_texto = format ["<t size='0.55'>" + "%5 | HR: %1 | Your Money: %6 € | FIA Money: %2 € | %9 Support: %3 | %10 Support: %4 | %7 | %8", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", player getVariable ["Rank_PBar", "Init"], player getVariable "dinero", server getVariable "BE_PBar", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
				} else {
					_texto = format ["<t size='0.55'>" + "%5 | HR: %1 | Your Money: %6 € | FIA Money: %2 € | %8 Support: %3 | %9 Support: %4 | %7", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", player getVariable ["Rank_PBar", "Init"], player getVariable "dinero", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
				};
			};
		//if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
		if (_texto != _viejoTexto) then
			{
			//[_texto,-0.1,-0.4,601,0,0,5] spawn bis_fnc_dynamicText;
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_viejoTexto = _texto;
			};
		if (player == leader (group player)) then
			{
			if (not(group player in (hcAllGroups player))) then {player hcSetGroup [group player]};
			};
		sleep 1;
		};
	}
else
	{
	while {showStatistics} do
		{
		waitUntil {sleep 0.5; player == player getVariable ["owner",player]};
		if (activeBE) then {
			_texto = format ["<t size='0.55'>" + "HR: %1 | FIA Money: %2 € | %7 Support: %3 | %8 Support: %4 | %5 | %6", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", server getVariable "BE_PBar", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
		} else {
			_texto = format ["<t size='0.55'>" + "HR: %1 | FIA Money: %2 € | %6 Support: %3 | %7 Support: %4 | %5", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", ["Overt", "<t color='#1DA81D'>Incognito</t>"] select (captive player), A3_Str_BLUE, A3_Str_RED];
		};
		//if (captive player) then {_texto = format ["%1 ON",_texto]} else {_texto = format ["%1 OFF",_texto]};
		if (_texto != _viejoTexto) then
			{
			//[_texto,-0.1,-0.4,601,0,0,5] spawn bis_fnc_dynamicText;
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_viejoTexto = _texto;
			};
		sleep 1;
		};
	};
