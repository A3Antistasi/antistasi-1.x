if (!hasInterface) exitWith {};

_counter = _this select 0;
_del = _this select 1;

_xc = safezoneX + 0.43 * safezoneW;
_yc = safezoneY + 0.05 * safezoneH;

if !(_del) then {
	with uiNamespace do {
		ctrlDelete (uiNamespace getVariable "pBar");
		ctrlDelete (uiNamespace getVariable "pBartext");
		pBar = findDisplay 46 ctrlCreate ["RscProgress", -1];
		pBar ctrlSetPosition [ _xc, _yc];
		pBar progressSetPosition 0;
		pBar ctrlSetTextColor [0.73,0.24,0.11,1];
		pBar ctrlCommit 0;

		pBartext = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
		pBartext ctrlSetPosition [ _xc, _yc];
		pBartext ctrlCommit 0;


	    [ "TIMER", "onEachFrame", {
	        params[ "_start", "_end" ];
	        _progress = linearConversion[ _start, _end, time, 0, 1 ];
	        (uiNamespace getVariable "pBar") progressSetPosition _progress;
	        (uiNamespace getVariable "pBartext") ctrlSetStructuredText parseText format["%1%2", round(100*_progress), "%"];

			if ( _progress > 1 ) then {
	            [ "TIMER", "onEachFrame" ] call BIS_fnc_removeStackedEventHandler;
				ctrlDelete (uiNamespace getVariable "pBar");
				ctrlDelete (uiNamespace getVariable "pBartext");

	        };
	    }, [ time, time + _counter ] ] call BIS_fnc_addStackedEventHandler;
	};
}
else {
	with uiNamespace do {
		ctrlDelete (uiNamespace getVariable "pBar");
		ctrlDelete (uiNamespace getVariable "pBartext");
	};
};