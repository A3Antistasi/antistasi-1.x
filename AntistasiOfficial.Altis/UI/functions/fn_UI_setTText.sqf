params [["_text", ""]];

if !(_text == "") then {_text = localize _text};
findDisplay 100 displayCtrl 1100 ctrlSetStructuredText parseText format ["<t font=""PuristaMedium"">%1</t>",_text];
