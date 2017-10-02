params [["_text", ""]];

if !(_text == "") then {_text = localize _text};
findDisplay 100 displayCtrl 1100 ctrlSetStructuredText parseText _text;
