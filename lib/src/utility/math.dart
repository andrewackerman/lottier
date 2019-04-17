import 'dart:math' as Math;

export 'dart:math';

double lerp(num a, num b, double t) => (1 - t) * a + t * b; 
int lerpInt(int a, int b, double t) => lerp(a, b, t).toInt();