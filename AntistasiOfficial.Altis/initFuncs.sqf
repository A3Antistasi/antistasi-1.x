
call compile preprocessFileLineNumbers "Compositions\FIA_RB.sqf";
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
call compile preprocessFileLineNumbers "Lists\gearList.sqf";

minefieldAAF = compile preProcessFileLineNumbers "CREATE\minefieldAAF.sqf";
tempMoveMrk = compile preProcessFileLineNumbers "tempMoveMrk.sqf";
hasRadio = compile preProcessFileLineNumbers "AI\hasRadio.sqf";
accionArsenal = compile preProcessFileLineNumbers "Municion\accionArsenal.sqf";
AAFKilledEH = compile preProcessFileLineNumbers "AI\AAFKilledEH.sqf";
handleDamageAAF = compile preProcessFileLineNumbers "Revive\handleDamageAAF.sqf";
CSATVEHinit = compile preProcessFileLineNumbers "CREATE\CSATVEHinit.sqf";
NATOVEHinit = compile preProcessFileLineNumbers "CREATE\NATOVEHinit.sqf";
civVEHinit = compile preProcessFileLineNumbers "CREATE\civVEHinit.sqf";
smokeCoverAuto = compile preProcessFileLineNumbers "AI\smokeCoverAuto.sqf";
landThreatEval = compile preProcessFileLineNumbers "AI\landThreatEval.sqf";
mortarPos = compile preProcessFileLineNumbers "CREATE\mortarPos.sqf";
REP_Antena = compile preProcessFileLineNumbers "Missions\REP_Antena.sqf";
placementSelection = compile preProcessFileLineNumbers "placementselection.sqf";
isMember = compile preProcessFileLineNumbers "orgPlayers\isMember.sqf";
vaciar = compile preProcessFileLineNumbers "Municion\vaciar.sqf";
AS_specOP = compile preProcessFileLineNumbers "Missions\AS_specOP.sqf";
artySupport = compile preProcessFileLineNumbers "AI\artySupport.sqf";
distanceUnits = compile preProcessFileLineNumbers "distanceUnits.sqf";
borrarTask = compile preProcessFileLineNumbers "Missions\borrarTask.sqf";
undercover = compile preProcessFileLineNumbers "undercover.sqf";
puertasLand = compile preProcessFileLineNumbers "AI\puertasLand.sqf";
AAthreatEval = compile preProcessFileLineNumbers "AI\AAthreatEval.sqf";
mortyAI = compile preProcessFileLineNumbers "AI\mortyAI.sqf";
surrenderAction = compile preProcessFileLineNumbers "AI\surrenderAction.sqf";
guardDog = compile preProcessFileLineNumbers "AI\guardDog.sqf";
VEHdespawner = compile preProcessFileLineNumbers "CREATE\VEHdespawner.sqf";
randomRifle = compile preProcessFileLineNumbers "Municion\randomRifle.sqf";
findSafeRoadToUnload = compile preProcessFileLineNumbers "AI\findSafeRoadToUnload.sqf";
ranksMP = compile preProcessFileLineNumbers "OrgPlayers\ranksMP.sqf";
undercoverAI = compile preProcessFileLineNumbers "AI\undercoverAI.sqf";
memberAdd = compile preProcessFileLineNumbers "OrgPlayers\memberAdd.sqf";
donateMoney = compile preProcessFileLineNumbers "OrgPlayers\donateMoney.sqf";
stavrosSteal = compile preProcessFileLineNumbers "OrgPlayers\stavrosSteal.sqf";
resourcesPlayer = compile preProcessFileLineNumbers "OrgPlayers\resourcesPlayer.sqf";
medUnconscious = compile preProcessFileLineNumbers "Revive\medUnconscious.sqf";
respawn = compile preProcessFileLineNumbers "Revive\respawn.sqf";
handleDamage = compile preProcessFileLineNumbers "Revive\handleDamage.sqf";
initRevive = compile preProcessFileLineNumbers "Revive\initRevive.sqf";
askForHelp = compile preProcessFileLineNumbers "AI\askForHelp.sqf";
medHeal = compile preProcessFileLineNumbers "AI\medHeal.sqf";
coverWithSmoke = compile preProcessFileLineNumbers "AI\coverWithSmoke.sqf";
returnMuzzle = compile preProcessFileLineNumbers "returnMuzzle.sqf";
autoRearm = compile preProcessFileLineNumbers "AI\autoRearm.sqf";
destroyCheck = compile preProcessFileLineNumbers "destroyCheck.sqf";
groupComposition = compile preProcessFileLineNumbers "REINF\groupComposition.sqf";
vehiclePrice = compile preProcessFileLineNumbers "REINF\vehiclePrice.sqf";
resourcesAAF = compile preProcessFileLineNumbers "resourcesAAF.sqf";
VANTinfo = compile preProcessFileLineNumbers "AI\VANTinfo.sqf";
garrisonAdd = compile preProcessFileLineNumbers "REINF\garrisonAdd.sqf";
garrisonDialog = compile preProcessFileLineNumbers "REINF\garrisonDialog.sqf";
CSATpunish = compile preProcessFileLineNumbers "CREATE\CSATpunish.sqf";
vehicleRemover = compile preProcessFileLineNumbers "CREATE\vehicleRemover.sqf";
NATOCAS = compile preProcessFileLineNumbers "REINF\NATOCAS.sqf";
NATOArty = compile preProcessFileLineNumbers "REINF\NATOArty.sqf";
NATOCrate = compile preProcessFileLineNumbers "Municion\NATOCrate.sqf";
NATOAmmo = compile preProcessFileLineNumbers "Missions\NATOAmmo.sqf";
puestoDialog = compile preProcessFileLineNumbers "puestoDialog.sqf";
mineDialog = compile preProcessFileLineNumbers "Dialogs\mineDialog.sqf";
onPlayerDisconnect = compile preProcessFileLineNumbers "onPlayerDisconnect.sqf";
playerScoreAdd = compile preProcessFileLineNumbers "orgPlayers\playerScoreAdd.sqf";
assignStavros = compile preProcessFileLineNumbers "orgPlayers\assignStavros.sqf";
stavrosInit = compile preProcessFileLineNumbers "orgPlayers\stavrosInit.sqf";
createFIAEmplacement = compile preProcessFileLineNumbers "CREATE\createFIAEmplacement.sqf";
crearPuestosFIA = compile preProcessFileLineNumbers "crearPuestosFIA.sqf";
postmortem = compile preProcessFileLineNumbers "REINF\postmortem.sqf";
commsMP = compile preProcessFileLineNumbers "commsMP.sqf";
autoGarrison = compile preProcessFileLineNumbers "REINF\autoGarrison.sqf";
resourceCheckSkipTime = compile preProcessFileLineNumbers "resourcecheckSkipTime.sqf";
CONVOY = compile preProcessFileLineNumbers "Missions\CONVOY.sqf";
RES_Prisioneros = compile preProcessFileLineNumbers "Missions\RES_Prisioneros.sqf";
RES_Refugiados = compile preProcessFileLineNumbers "Missions\RES_Refugiados.sqf";
LOG_Bank = compile preProcessFileLineNumbers "Missions\LOG_Bank.sqf";
LOG_Ammo = compile preProcessFileLineNumbers "Missions\LOG_Ammo.sqf";
DES_Vehicle = compile preProcessFileLineNumbers "Missions\DES_Vehicle.sqf";
DES_Heli = compile preProcessFileLineNumbers "Missions\DES_Heli.sqf";
DES_Antena = compile preProcessFileLineNumbers "Missions\DES_Antena.sqf";
DES_EnemySuppression = compile preProcessFileLineNumbers "Missions\DES_EnemySuppression.sqf";
CON_Puestos = compile preProcessFileLineNumbers "Missions\CON_Puestos.sqf";
ataqueHQ = compile preProcessFileLineNumbers "Missions\ataqueHQ.sqf";
AS_Oficial = compile preProcessFileLineNumbers "Missions\AS_Oficial.sqf";
ASS_Traidor = compile preProcessFileLineNumbers "Missions\ASS_Traidor.sqf";
missionrequest = compile preProcessFileLineNumbers "Missions\missionrequest.sqf";
missionrequestAUTO = compile preProcessFileLineNumbers "Missions\missionrequestAUTO.sqf";
cajaAAF = compile preProcessFileLineNumbers "Municion\cajaAAF.sqf";
createNATObases = compile preProcessFileLineNumbers "CREATE\createNATObases.sqf";
resourcesFIA = compile preProcessFileLineNumbers "resourcesFIA.sqf";
prestige = compile preProcessFileLineNumbers "prestige.sqf";
createCIV = compile preProcessFileLineNumbers "CREATE\createCIV.sqf";
createFIAresources = compile preProcessFileLineNumbers "CREATE\createFIAresources.sqf";
createFIAOutpost = compile preProcessFileLineNumbers "CREATE\createFIAOutpost.sqf";
createFIApower = compile preProcessFileLineNumbers "CREATE\createFIApower.sqf";
createNATOaerop = compile preProcessFileLineNumbers "CREATE\createNATOaerop.sqf";
createSupplyGroup = compile preProcessFileLineNumbers "CREATE\createSupplyGroup.sqf";
createSupplyBox = compile preProcessFileLineNumbers "CREATE\createSupplyBox.sqf";
reinfPlayer = compile preProcessFileLineNumbers "REINF\reinfplayer.sqf";
addFIAsquadHC = compile preProcessFileLineNumbers "REINF\addFIAsquadHC.sqf";
addFIAveh = compile preProcessFileLineNumbers "REINF\addFIAveh.sqf";
FIAskillAdd = compile preProcessFileLineNumbers "REINF\FIAskillAdd.sqf";
CSATinit = compile preProcessFileLineNumbers "CREATE\CSATinit.sqf";
CSATtimetoreveal = compile preProcessFileLineNumbers "CREATE\CSATtimetoreveal.sqf";
NATOinit = compile preProcessFileLineNumbers "CREATE\NATOinit.sqf";
NATOinitCA = compile preProcessFileLineNumbers "CREATE\NATOinitCA.sqf";
CIVinit = compile preProcessFileLineNumbers "CREATE\CIVinit.sqf";
VEHinit = compile preProcessFileLineNumbers "CREATE\VEHinit.sqf";
patrolCA = compile preProcessFileLineNumbers "CREATE\patrolCA.sqf";
combinedCA = compile preProcessFileLineNumbers "CREATE\combinedCA.sqf";
NATOCA = compile preProcessFileLineNumbers "CREATE\NATOCA.sqf";
AAFeconomics = compile preProcessFileLineNumbers "AAFeconomics.sqf";
distancias3 = compile preProcessFileLineNumbers "distancias3.sqf";
inmuneConvoy = compile preProcessFileLineNumbers "AI\inmuneConvoy.sqf";
smokeCover = compile preProcessFileLineNumbers "AI\smokeCover.sqf";
fastropeAAF = compile preProcessFileLineNumbers "AI\fastropeAAF.sqf";
fastropeCSAT = compile preProcessFileLineNumbers "AI\fastropeCSAT.sqf";
fastropeNATO = compile preProcessFileLineNumbers "AI\fastropeNATO.sqf";
airdrop = compile preProcessFileLineNumbers "AI\airdrop.sqf";
airstrike = compile preProcessFileLineNumbers "AI\airstrike.sqf";
artilleria = compile preProcessFileLineNumbers "AI\artilleria.sqf";
artilleriaNATO = compile preProcessFileLineNumbers "AI\artilleriaNATO.sqf";
dismountFIA = compile preProcessFileLineNumbers "AI\dismountFIA.sqf";
sizeMarker = compile preProcessFileLineNumbers "sizeMarker.sqf";
mrkWIN = compile preProcessFileLineNumbers "mrkWIN.sqf";
mrkLOOSE = compile preProcessFileLineNumbers "mrkLOOSE.sqf";
moveHQ = compile preProcessFileLineNumbers "moveHQ.sqf";
buildHQ = compile preProcessFileLineNumbers "buildHQ.sqf";
statistics = compile preProcessFileLineNumbers "statistics.sqf";
/*
Generics
*/
createAirbase = compile preProcessFileLineNumbers "CREATE\createAirbase.sqf";
createArtillery = compile preProcessFileLineNumbers "CREATE\createArtillery.sqf";
createBase = compile preProcessFileLineNumbers "CREATE\createBase.sqf";
createCity = compile preProcessFileLineNumbers "CREATE\createCity.sqf";
createOutpost = compile preProcessFileLineNumbers "CREATE\createOutpost.sqf";
createPower = compile preProcessFileLineNumbers "CREATE\createPower.sqf";
createResources = compile preProcessFileLineNumbers "CREATE\createResources.sqf";
createRoadblock = compile preProcessFileLineNumbers "CREATE\createRoadblock.sqf";
createRoadblock2 = compile preProcessFileLineNumbers "CREATE\createRoadblock2.sqf";
createWatchpost = compile preProcessFileLineNumbers "CREATE\createWatchpost.sqf";
createAAsite = compile preProcessFileLineNumbers "CREATE\createAAsite.sqf";
genInit = compile preProcessFileLineNumbers "CREATE\genInit.sqf";
genInitBASES = compile preProcessFileLineNumbers "CREATE\genInitBASES.sqf";
genRoadPatrol = compile preProcessFileLineNumbers "CREATE\genRoadPatrol.sqf";
genVEHinit = compile preProcessFileLineNumbers "CREATE\genVEHinit.sqf";

createCampFIA = compile preProcessFileLineNumbers "CREATE\createCampFIA.sqf";
createNATOpuesto = compile preProcessFileLineNumbers "CREATE\createNATOpuesto.sqf";
NATOQRF = compile preProcessFileLineNumbers "CREATE\NATOQRF.sqf";
enemyQRF = compile preprocessFileLineNumbers "CREATE\enemyQRF.sqf";

NATOUAV = compile preProcessFileLineNumbers "REINF\NATOUAV.sqf";
NATORoadblock = compile preProcessFileLineNumbers "REINF\NATORoadblock.sqf";

ftravelDialog = compile preProcessFileLineNumbers "ftravelDialog.sqf";
establishCamp = compile preProcessFileLineNumbers "establishCamp.sqf";
pBarMP = compile preProcessFileLineNumbers "pBarMP.sqf";
createConv = compile preProcessFileLineNumbers "createConv.sqf";
jamLRRadio = compile preProcessFileLineNumbers "jamLRRadio.sqf";
teleport = compile preprocessFileLineNumbers "teleport.sqf";

CON_AA = compile preProcessFileLineNumbers "Missions\CON_AA.sqf";
CON_Power = compile preProcessFileLineNumbers "Missions\CON_Power.sqf";
DEF_Camp = compile preProcessFileLineNumbers "Missions\DEF_Camp.sqf";
FND_CivCon = compile preProcessFileLineNumbers "Missions\FND_CivCon.sqf";
FND_ExpDealer = compile preProcessFileLineNumbers "Missions\FND_ExpDealer.sqf";
FND_MilCon = compile preProcessFileLineNumbers "Missions\FND_MilCon.sqf";
//INT_Reinforcements = compile preProcessFileLineNumbers "Missions\INT_Reinforcements.sqf"; Stef Disabled: useless
LOG_Medical = compile preProcessFileLineNumbers "Missions\LOG_Medical.sqf";
misReqCiv = compile preProcessFileLineNumbers "Missions\misReqCiv.sqf";
misReqMil = compile preProcessFileLineNumbers "Missions\misReqMil.sqf";
missionSelect = compile preProcessFileLineNumbers "Missions\missionSelect.sqf";
PR_Brainwash = compile preProcessFileLineNumbers "Missions\PR_Brainwash.sqf";
PR_Pamphlet = compile preProcessFileLineNumbers "Missions\PR_Pamphlet.sqf";
DES_fuel = compile preProcessFileLineNumbers "Missions\DES_Fuel.sqf";
//AS_forest = compile preProcessFileLineNumbers "Missions\AS_ForestPatrol.sqf";  Stef - disabled because they're oftenly messy, it add 10 units to the pool mostly for no reason.
AS_Mayor = compile preProcessFileLineNumbers "Missions\AS_Mayor.sqf";

HQ_adds = compile preprocessFileLineNumbers "Compositions\HQ_adds.sqf";
compNATORoadblock = compile preprocessFileLineNumbers "Compositions\cmpNATO_RB.sqf";

buyGear = compile preProcessFileLineNumbers "Municion\buyGear.sqf";
emptyCrate = compile preProcessFileLineNumbers "Municion\emptyCrate.sqf";

attackWaves = compile preprocessFileLineNumbers "Scripts\attackWaves.sqf";
cleanGear = compile preProcessFileLineNumbers "OrgPlayers\cleanGear.sqf";
localSupport = compile preprocessFileLineNumbers "Scripts\localSupport.sqf";
petrosAnimation = compile preprocessFileLineNumbers "Scripts\petrosAnimation.sqf";
rankCheck = compile preprocessFileLineNumbers "Scripts\rankCheck.sqf";

ACErespawn = compile preProcessFileLineNumbers "Revive\ACErespawn.sqf";

if (activeJNA) then {
	if (isServer) then {
		[(unlockedWeapons + unlockedMagazines + unlockedItems + unlockedBackpacks) arrayIntersect (unlockedWeapons + unlockedMagazines + unlockedItems + unlockedBackpacks)] call AS_fnc_JNA_setupGear;
	};
};

call AS_fnc_saveFunctions;

call compile preprocessFileLineNumbers "Compositions\campList.sqf";
call compile preprocessFileLineNumbers "Compositions\cmpMTN.sqf";
call compile preprocessFileLineNumbers "Compositions\cmpOP.sqf";
call compile preprocessFileLineNumbers "Compositions\artillery.sqf";

if ((isMultiplayer) and (isServer)) then {[[petros,"locHint","STR_HINTS_INITCUNCS"],"commsMP"] call BIS_fnc_MP};
