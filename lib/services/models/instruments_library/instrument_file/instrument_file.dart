import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

abstract class InstrumentFile {
  Instruments get instrument;
  String get name;
  String get path;

  bool get isSelected;
  InstrumentFile copyWith({
    Instruments? instrument,
    String? name,
    String? path,
    Scale? originalScale,
    bool? isSelected,
  });
}
