import 'package:flutter_multiple_tracks/services/models/instruments.dart';

abstract class InstrumentFile {
  Instruments get instrument;
  String get name;
  String get path;
  bool get isSelected;

  InstrumentFile copyWith({
    String? name,
    String? path,
    bool? isSelected,
  });
}
