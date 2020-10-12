proc optmodel;

var Xah, Xas, Xnh, Xns, Xkh, Xks;
var Ya binary;
var Yn binary;
var Yk binary;

minimize Z = 17.85*Xah + 25.4*Xas + 25.7*Xkh + 22.75*Xks + 26.3*Xnh + 19.85*Xns + 1859*Ya + 330*Yk + 2204*Yn;

con Xah + Xnh + Xkh >= 383;
con Xas + Xns + Xks >= 550;

con Xah + Xas <= 799;
con Xkh + Xks <= 470;
con Xnh + Xns <= 632;


con Xah + Xas <= 791*Ya;
con Xkh + Xks <= 447*Yk;
con Xnh + Xns <= 613*Yn;

con Xah + Xas >= 126*Ya;
con Xkh + Xks >= 163*Yk;
con Xnh + Xns >= 134*Yn;

con Xah >= 0;
con Xas >= 0;
con Xnh >= 0;
con Xns >= 0;
con Xkh >= 0;
con Xks >= 0;

solve;
print Z Xah Xas Xnh Xns Xkh Xks Ya Yk Yn;
quit;








