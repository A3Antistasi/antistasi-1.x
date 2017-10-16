createDialog "members_menu";

waitUntil {dialog};
waitUntil {!dialog};
if (isNil"membersPool") then
	{
	membersPool = [];
	publicVariable "membersPool";
	hint "Server Membership Disabled.\n\nAnyone can use the HQ Ammobox and become Commander (if Switch Commander is enabled).\n\nIf you load a session with this feature enabled, it will become enabled.\n\nUse this option for Private Server environments.";
	[] execVM "Dialogs\firstLoad.sqf";
	};