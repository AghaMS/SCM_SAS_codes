proc optmodel;
var Xge, Xke, Xgt, Xkt, Xgn, Xkn;
var Ye binary;
var Yt binary;
var Yn binary;

minimize Z = 21*Xge + 22.5*Xke + 22.5*Xgt + 24.5*Xkt + 23*Xgn + 25.5*Xkn;

con Xge + Xke <= 425;
con Xgt + Xkt <= 400;
con Xgn + Xkn <= 750;

con Xge + Xgt + Xgn >= 550;
con Xke + Xkt + Xkn >= 450;

con Xge + Xke - 425*Ye <= 0;
con Xgt + Xkt - 400*Yt <= 0;
con Xgn + Xkn - 750*Yn <= 0;

con Ye +Yt +Yn <= 2;

con Xge >= 0;
con Xke >= 0;
con Xgt >= 0;
con Xkt >= 0;
con Xgn >= 0;
con Xkn >= 0;

solve;
print Z Xge Xke Xgt Xkt Xgn Xkn Ye Yt Yn;
quit;