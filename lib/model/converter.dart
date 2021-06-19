import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Converter{

  lks94TOwgs84(var x, var y) {
		//var distsize = 3;
		//var j = 0;
		var units = 1;
		
		var k  = 0.9998;
		var a = 6378137;
		var f = 1/298.257224563;
		var b = a*(1-f);
		var e2 = (a*a-b*b)/(a*a);
		//var e = sqrt(e2);
		//var ei2 = (a*a-b*b)/(b*b);
		//var ei = sqrt(ei2);
		var n = (a-b)/(a+b);
		
		var G = a*(1-n)*(1-n*n)*(1+(9/4)*n*n+(255/64)*pow(n, 4))*(pi/180);
		var north = (y-0)*units;
		var east = (x-500000)*units;
		var m = north/k;
		var sigma = (m*pi)/(180*G);
		var footlat = sigma+((3*n/2)-(27*pow(n, 3)/32))*sin(2*sigma)+((21*n*n/16)-(55*pow(n, 4)/32))*sin(4*sigma)+(151*pow(n, 3)/96)*sin(6*sigma)+(1097*pow(n, 4)/512)* sin(8*sigma);
		var rho = a*(1-e2)/pow(1-(e2*sin(footlat)*sin(footlat)), (3/2));
		var nu = a/sqrt(1-(e2*sin(footlat)*sin(footlat)));
		var psi = nu/rho;
		var t = tan(footlat);
		x = east/(k*nu);
		
		var laterm1 = (t/(k*rho))*(east*x/2);
		var laterm2 = (t / (k * rho )) * ( east * pow(x, 3) / 24) * (-4 * psi * psi + 9 * psi * (1 - t * t) + 12 * t * t );
		var laterm3 = (t / (k * rho )) * ( east * pow(x, 5) / 720) * (8 * pow(psi, 4) * (11 - 24 * t * t) - 12 * pow(psi, 3) * (21 - 71 * t * t) + 15 * psi * psi * (15 - 98 * t * t + 15 * pow(t, 4)) + 180 * psi * (5 * t * t - 3 * pow(t, 4)) + 360 * pow(t, 4));
		var laterm4 = (t / (k * rho )) * ( east * pow(x, 7) / 40320) * (1385 + 3633 * t * t + 4095 * pow(t, 4) + 1575 * pow(t, 6));
		var latrad = footlat - laterm1 + laterm2 - laterm3 + laterm4;
		
		var latDeg = degrees(latrad);
		var seclat = 1/cos(footlat);
		
		var loterm1 = x * seclat;
		var loterm2 = (pow(x, 3) / 6) * seclat * (psi + 2 * t * t);
		var loterm3 = (pow(x, 5) / 120) * seclat * (-4 * pow(psi, 3) * (1 - 6 * t * t) + psi * psi * (9 - 68 * t * t) + 72 * psi * t * t + 24 * pow(t, 4));
		var loterm4 = (pow(x, 7) / 5040) * seclat * (61 + 662 * t * t + 1320 * pow(t, 4) + 720 * pow(t, 6));
		var w = loterm1 - loterm2 + loterm3 - loterm4;
		var longrad = radians(24) + w;
		var lonDeg = degrees(longrad);
		
		return [double.parse(latDeg.toStringAsFixed(5)), double.parse(lonDeg.toStringAsFixed(5))];
	}

  wgs84TOlks94(var lat, var lon) {
      var distsize = 3;
      //var j = 0;
      var units = 1;
      
      var latddd = lat;
      var latrad = radians(latddd);
      var londdd = lon;
      //var lonrad = radians(londdd);
      
      var k = 0.9998;
      var a = 6378137;
      var f = 1 / 298.257223563;
      var b = a * (1 - f);
      var e2 = (a * a - b * b) / (a * a);
      //var e = sqrt(e2);
      //var ei2 = (a * a - b * b) / (b * b);
      //var ei = sqrt(ei2);
      //var n = (a - b) / (a + b);
      //var G = a * (1 - n) * (1 - n * n) * (1 + (9 / 4) * n * n + (255 / 64) * pow(n, 4)) * (pi / 180);

      var w = londdd - 24;
      w = radians(w);
      var t = tan(latrad);
      var rho = a * (1 - e2) / pow(1 - (e2 * sin(latrad) * sin(latrad)), (3 / 2));
      var nu = a / sqrt(1 - (e2 * sin(latrad) * sin(latrad)));
      
      var psi = nu / rho;
      var coslat = cos(latrad);
      var sinlat = sin(latrad);
      
      var a0 = 1 - (e2 / 4) - (3 * e2 * e2 / 64) - (5 * pow(e2, 3) / 256);
      var a2 = (3 / 8) * (e2 + (e2 * e2 / 4) + (15 * pow(e2, 3) / 128));
      var a4 = (15 / 256) * (e2 * e2 + (3 * pow(e2, 3) / 4));
      var a6 = 35 * pow(e2, 3) / 3072;
      var m = a * ((a0 * latrad) - (a2 * sin(2 * latrad)) + (a4 * sin(4 * latrad)) - (a6 * sin(6 * latrad)));
      
      var eterm1 = (w * w / 6) * coslat * coslat * (psi - t * t);
      var eterm2 = (pow(w, 4) / 120) * pow(coslat, 4) * (4 * pow(psi, 3) * (1 - 6 * t * t) + psi * psi * (1 + 8 * t * t) - psi * 2 * t * t + pow(t, 4));
      var eterm3 = (pow(w, 6) / 5040) * pow(coslat, 6) * (61 - 479 * t * t + 179 * pow(t, 4) - pow(t, 6));
      var dE = k * nu * w * coslat * (1 + eterm1 + eterm2 + eterm3);
      
      var east = roundoff(500000 + (dE / units), distsize);

      var nterm1 = (w * w / 2) * nu * sinlat * coslat;
      var nterm2 = (pow(w, 4) / 24) * nu * sinlat * pow(coslat, 3) * (4 * psi * psi + psi - t * t);
      var nterm3 = (pow(w, 6) / 720) * nu * sinlat * pow(coslat, 5) * (8 * pow(psi, 4) * (11 - 24 * t * t) - 28 * pow(psi, 3) * (1 - 6 * t * t) + psi * psi * (1 - 32 * t * t) - psi * 2 * t * t + pow(t, 4));
      var nterm4 = (pow(w, 8) / 40320) * nu * sinlat * pow(coslat, 7) * (1385 - 3111 * t * t + 543 * pow(t, 4) - pow(t, 6));
      var dN = k * (m + nterm1 + nterm2 + nterm3 + nterm4);
      var north = roundoff(0 + (dN / units), distsize);

      return [east.toInt(), north.toInt()];
    }
    int roundoff(var x, var y) {
      x = ((x * pow(10, y)) / pow(10, y)).round();
      return x;
    }
}



