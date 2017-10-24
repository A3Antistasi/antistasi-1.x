if !(isServer) exitWith {};
//This is the path to external storage folder(folder should be in the root of arma3 folder).
externalConfigFolder = "\A3Antistasi";
private _mList = [];

diag_log format ["isFilePatchingEnabled: %1", isFilePatchingEnabled];
if(isFilePatchingEnabled) then {
    private _memberList = loadFile (externalConfigFolder + "\memberlist.txt");
    if ( _memberList != "" ) then
	{
	    //Members list is in form of CRLF separated playerIds
	    _mList = _memberList splitString toString [13,10];
	    diag_log format ["DEBUG: External content from %1",externalConfigFolder + "\memberlist.txt"];
	};
};

{
    //comma (,) and whitespace are the delimeters, only the first element is considered the ID
    private _memberID = (_x splitString ", ") select 0;
    diag_log format ["DEBUG: +memberID: %1", _memberID];
    membersPool pushBackUnique _memberID;
} forEach _mList;
publicVariable "membersPool";
