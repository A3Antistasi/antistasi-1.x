/*
Saves data with INIDBI
INIDBI limit is 8 kB per key. This function divides data if it's bigger than 8 kB and writes it in parts.
Parameters:
[_inidbi, _section, _key, _value]
Returns:
nothing
Author: Sparker
*/



params ["_inidbi", "_section", "_key", "_value"];

private _partSize = 7*1024; //8192; //7 kBytes should be enough for everyone??
private _valueStr = str _value;
private _numParts = ceil((count _valueStr) / _partSize); //The number of parts this variable needs to be split into

//Delete data if it was previously saved with a single part
["deleteKey", [_section, _key]] call _inidbi; //Delete the key

//Delete data if it was previously saved with many parts
private _counter = 0;
private _rdwrkey = _key + "_0";
private _string = ["read", [_section, _rdwrkey, ""]] call _inidbi;
while {! (_string isEqualTo "")} do
{
	["deleteKey", [_section, _rdwrkey]] call _inidbi; //Delete the key
	_counter = _counter + 1;
	_rdwrkey = _key + "_" + (str _counter);
	_string = ["read", [_section, _rdwrkey, ""]] call _inidbi; //Read the key with next index
};


//Save the new data
if(_numParts == 1) then
{
	//Write data as a single part
	["write", [_section, _key, _value]] call _inidbi;
}
else
{
	//Write data by parts

	//First preprocess string and replace all " inside it with single quote ' sign
	//Otherwise if we have not even amount of "" signs in a string it's going to break
	//Then replace all separators | with something else because why is it made so bad?
	private _strArray = toArray _valueStr;
	{if (_x == 39) then {_strArray set [_foreachindex, 42];};} forEach _strArray; //Replace all ' with * in case someone has put it in his nickname
	{if (_x == 34) then {_strArray set [_foreachindex, 39];};} forEach _strArray; //94
	//{if (_x == 124) then {_strArray set [_foreachindex, 221];};} forEach _strArray; // | -> ¦
	_valueStr = toString _strArray;

	_counter = 0;
	_rdwrkey = _key + "_0";
	private _count = 0;
	while {_counter < _numParts} do
	{
		_string = _valueStr select [_counter*_partSize, _partSize];
		["write", [_section, _rdwrkey, _string]] call _inidbi;
		_count = count _string;
		//diag_log format ["Writing at %1, part size: %2, data size: %3", _counter*_partSize, _partSize, _count];
		//diag_log format ["Data: %1", _string];
		_counter = _counter + 1;
		_rdwrkey = _key + "_" + str _counter;
	};
};