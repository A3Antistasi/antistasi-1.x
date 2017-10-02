if !(worldName == "Altis") exitWith {};

{
	server setVariable [_x select 0,_x select 1]
} forEach [
	["Therisa",154],["Zaros",371],["Poliakko",136],["Katalaki",95],["Alikampos",115],["Neochori",309],["Stavros",122],["Lakka",173],["AgiosDionysios",84],["Panochori",264],["Topolia",33],["Ekali",9],["Pyrgos",531],["Orino",45],["Neri",242],["Kore",133],["Kavala",660],["Aggelochori",395],["Koroni",32],["Gravia",291],["Anthrakia",143],["Syrta",151],["Negades",120],["Galati",151],["Telos",84],["Charkia",246],["Athira",342],["Dorida",168],["Ifestiona",48],["Chalkeia",214],["AgiosKonstantinos",39],["Abdera",89],["Panagia",91],["Nifi",24],["Rodopoli",212],["Kalithea",36],["Selakano",120],["Frini",69],["AgiosPetros",11],["Feres",92],["AgiaTriada",8],["Paros",396],["Kalochori",189],["Oreokastro",63],["Ioannina",48],["Delfinaki",29],["Sofia",179],["Molos",188]
	];
call compile preprocessFileLineNumbers "roadsDB.sqf";

power = ["power","power_1","power_2","power_3","power_5","power_6","power_8","power_9","power_10"];
bases = ["base","base_1","base_2","base_3","base_4","base_5","base_6","base_7","base_9","base_10","base_11","base_12"];
aeropuertos = ["airport","airport_1","airport_2","airport_3","airport_4","airport_5"];
recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"];
fabricas = ["factory","factory_1","factory_2","factory_3","factory_4","factory_5"];
puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13","puesto_14","puesto_15","puesto_16","puesto_17","puesto_18","puesto_19","puesto_20","puesto_21","puesto_22","puesto_23","puesto_24","puesto_25","puesto_26","puesto_27"];
puestosAA = ["puesto_1","puesto_2","puesto_6","puesto_17","puesto_23","puesto_27"];
puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4"];
controles = ["control","control_1","control_2","control_3","control_4","control_5","control_6","control_7","control_8","control_9","control_10","control_11","control_12","control_13","control_14","control_15","control_16","control_17","control_18","control_19","control_20","control_21","control_22","control_23","control_24","control_25","control_26","control_27","control_28","control_29","control_30","control_31","control_32","control_33","control_34","control_35","control_36","control_37","control_38","control_39","control_40","control_41","control_42","control_43","control_44","control_45","control_46","control_47","control_48","control_49","control_50","control_51","control_52","control_53","control_54","control_55","control_56","control_57","control_58","control_59","control_60","control_61","control_62","control_63","control_64","control_65","control_66","control_67","control_68","control_69","control_70","control_71","control_72","control_73","control_74","control_75"];
colinasAA = ["Agela","Agia Stemma","Agios Andreas","Agios Minas","Amoni","Didymos","Kira","Pyrsos","Riga","Skopos","Synneforos","Thronos"];
artyEmplacements = ["artillery_1", "artillery_2", "artillery_3", "artillery_4", "artillery_5"];
seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21","seaPatrol_22","seaPatrol_23","seaPatrol_24","seaPatrol_25","seaPatrol_26","seaPatrol_27"];

posAntenas = [[16085.1,16998,7.08781],[14451.5,16338,0.000358582],[15346.7,15894,-3.62396e-005],[9496.2,19318.5,0.601898],[20944.9,19280.9,0.201118],[17856.7,11734.1,0.863045],[20642.7,20107.7,0.236603],[9222.87,19249.1,0.0348206],[18709.3,10222.5,0.716034],[6840.97,16163.4,0.0137177],[19319.8,9717.04,0.215622],[19351.9,9693.04,0.639175],[10316.6,8703.94,0.0508728],[8268.76,10051.6,0.0100708],[4583.61,15401.1,0.262543],[4555.65,15383.2,0.0271606],[4263.82,20664.1,-0.0102234],[26274.6,22188.1,0.0139847],[26455.4,22166.3,0.0223694]];

posbancos = [[16633.3,12807,-0.635017],[3717.34,13391.2,-0.164862],[3692.49,13158.3,-0.0462093],[3664.31,12826.5,-0.379545]];

safeDistance_undercover = 350;
safeDistance_garage = 500;
safeDistance_recruit = 500;
safeDistance_garrison = 500;
safeDistance_fasttravel = 500;

static_defPosHQ = [3621.81,10283.2,0.00124454];

bld_smallBunker = "Land_BagBunker_Small_F";