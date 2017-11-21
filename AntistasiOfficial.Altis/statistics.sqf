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
				_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT1", server getVariable "hr", player getVariable ["Rank_PBar", "Init"], _nombreC, player getVariable "dinero",server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", server getVariable "BE_PBar", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
			} else {
				_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT2", server getVariable "hr", player getVariable ["Rank_PBar", "Init"], _nombreC, player getVariable "dinero",server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
			};
		}
		else
			{
				if (activeBE) then {
					_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT3", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", player getVariable ["Rank_PBar", "Init"], player getVariable "dinero", server getVariable "BE_PBar", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
				} else {
					_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT4", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", player getVariable ["Rank_PBar", "Init"], player getVariable "dinero", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
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
			_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT5", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", server getVariable "BE_PBar", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
		} else {
			_texto = format ["<t size='0.55'>" + localize "STR_UI_TOP_TEXT6", server getVariable "hr", server getVariable "resourcesFIA", server getVariable "PrestigeNATO", server getVariable "prestigeCSAT", [localize "STR_UI_TOP_OVERT",localize "STR_UI_TOP_INCOGNITO"] select (captive player), A3_Str_BLUE, A3_Str_RED];
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
