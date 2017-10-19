/*
	Author: Jeroen Notenbomer

	Description:
	Returns variable from ini file

	Parameter(s):
	CODE	database function
	STRING	section name
	STRING	key name
	ANY		default variable, this is returned if nothing(nil) was found

	Returns:
	ANY requested variable from INI file
*/
params [["_inidbi",{},[{}]], ["_section","",[""]], ["_key","",[""]], ["_default",nil]];

private _return = ["read", [_section, _key, objNull]] call _inidbi;//cant use default nil so we use objnull
diag_log format ["fn_loadDataINIDBI.sqf: reading key: %1, value :%2", _key, _return];
if(_return isEqualTo objNull)then{
	private _rdkey = "";
	private _count = 0;
	//private _return = ""; //Why make it private here?? It's going to be needed outside of IF-statement!
	_return = "";
	private _string = "";
	while{true}do{//loop all variables with save name
		_rdkey = (_key + "_" + str _count);
		_string = ["read", [_section, _rdkey, ""]] call _inidbi;

		if((_string isEqualTo ""))exitWith{};//no more found
		diag_log format ["fn_loadDataINIDBI.sqf: reading key: %1", _rdkey];

		_return = _return + _string;//combine
		_count = _count + 1; //Don't you want to increase it??
	};

	//If we exited while reading key_0 then the file doesn't even exist!
	if(_count == 0) then
	{
		_return = nil;
	}
	else
	{
		_return = (call compile _return); //we save variables as string, so we need to make them normal again
		//diag_log format ["fn_loadDataINIDBI.sqf: compiled key value: %1", _return];
	};
	//diag_log _return;

	//First preprocess string and replace all ^ inside it with " signs
	/*
	private _strArray = toArray _return;
	{if (_x == 94) then {_strArray set [_foreachindex, 34];};} forEach _strArray;
	_return = toString _strArray;
	*/
};
//return
if(isnil "_return")then{_return = _default;};
_return