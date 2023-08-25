import 'dart:math';

class AudioHelper {
  static double semitonesToPitchFactor(double semitones) {
    return pow(2, semitones / 12) as double;
  }

  static double pitchFactorToSemitones(double factor) {
    return 12 * log(factor) / log(2);
  }
}
