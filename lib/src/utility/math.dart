import 'dart:math' as Math;

export 'dart:math';

double lerp(num a, num b, double t) => (1 - t) * a + t * b; 
int lerpInt(int a, int b, double t) => lerp(a, b, t).toInt();

const double _toRadiansVal = 0.01745329252;
double toRadians(double degrees) => degrees * _toRadiansVal;

const double _toDegreesVal = 57.295779513;
double toDegrees(double radians) => radians * _toDegreesVal;