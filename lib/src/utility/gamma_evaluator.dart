import './math.dart' as Math;

class GammaEvaluator {

  static double _OECF_sRGB(double linear) {
    if (linear <= 0.0031308) 
      return linear * 12.92;
    return (Math.pow(linear, 1 / 2.4) * 1.055) - 0.055;
  }

  static double _EOCF_sRGB(double srgb) {
    if (srgb <= 0.04045)
      return srgb / 12.92;
    return Math.pow((srgb + 0.055) / 1.055, 2.4);
  }

  static int evaluate(double fraction, int start, int end) {
    double startA = ((start >> 24) & 0xff) / 255.0;
    double startR = ((start >> 16) & 0xff) / 255.0;
    double startG = ((start >> 8) & 0xff) / 255.0;
    double startB = (start & 0xff) / 255.0;

    double endA = ((end >> 24) & 0xff) / 255.0;
    double endR = ((end >> 16) & 0xff) / 255.0;
    double endG = ((end >> 8) & 0xff) / 255.0;
    double endB = (end & 0xff) / 255.0;

    startR = _EOCF_sRGB(startR);
    startG = _EOCF_sRGB(startG);
    startB = _EOCF_sRGB(startB);

    endR = _EOCF_sRGB(endR);
    endG = _EOCF_sRGB(endG);
    endB = _EOCF_sRGB(endB);

    double a = Math.lerp(startA, endA, fraction);
    double r = Math.lerp(startR, endR, fraction);
    double g = Math.lerp(startG, endG, fraction);
    double b = Math.lerp(startB, endB, fraction);

    a = a * 255;
    r = _OECF_sRGB(r) * 255;
    g = _OECF_sRGB(g) * 255;
    b = _OECF_sRGB(b) * 255;

    return a.round() << 24 | r.round() << 16 | g.round() << 8 | b.round();
  }

}