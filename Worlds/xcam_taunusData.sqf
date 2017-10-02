if !(worldName == "xcam_taunus") exitWith {};

power = []; // power plants
bases = []; // army bases
aeropuertos = []; // airports
recursos = []; // resources
fabricas = []; // factories
puestos = []; // outposts
puestosAA = []; // AA outposts
puertos = []; // harbours
controles = []; // roadblocks
colinas = []; // mountaintops
colinasAA = []; // mountaintops for special purposes (compositions, etc)
artyEmplacements = []; // artillery encampments
seaMarkers = []; // naval patrol zones

posAntenas = [[5931.85,1661.34,1.85011],[2181.58,1050.3,-0.000335693],[9101.07,3121.08,0.872818],[10113,5376.66,-1.52588e-005],[5994.99,7881.26,0],[7882.55,8022.01,0.000518799],[1766.35,10115.8,0],[1054.51,8647.81,0.00289917],[10392.6,3647.85,0],[12631.7,2444.19,0],[15333.1,3140.8,-0.000900269],[19447.5,388.336,-5.34058e-005],[20086.6,3438.89,-3.8147e-006],[17177.7,4815.76,0.000442505],[18583.8,5222.86,-1.52588e-005],[19686.1,6381.56,0],[14077.2,5427.67,0.000747681],[13793.4,9772.43,-3.05176e-005],[18947,11018.4,0],[6888.55,11653.5,0],[9858.19,12681.2,0],[4438.77,13167,0],[18309.4,15065.4,0],[10205,16171.1,0],[4204.51,16736.8,0],[1486.01,19352.1,1.21448],[13533.1,19217.1,3.05176e-005],[18196,19369.5,0.909241],[13693.2,14161,0]];

posbancos = [];

safeDistance_undercover = 250;
safeDistance_garage = 200;
safeDistance_recruit = 200;
safeDistance_garrison = 200;
safeDistance_fasttravel = 250;

static_defPosHQ = [5032.81,2611.2,0.00124454];

bld_smallBunker = "Land_BagBunker_01_small_green_F";