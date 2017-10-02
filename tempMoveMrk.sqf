_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_marcador setMarkerPos [0,0,0];
sleep 10;
_marcador setMarkerPos _pos;