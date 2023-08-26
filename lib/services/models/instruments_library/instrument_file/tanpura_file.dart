import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class TanpuraFile extends InstrumentFile {
  TanpuraFile({
    required this.instrument,
    required this.name,
    required this.path,
    required this.originalScale,
    this.isSelected = true,
  });

  @override
  final bool isSelected;

  @override
  final Instruments instrument;

  @override
  final String name;

  @override
  final String path;

  final Scale originalScale;
  factory TanpuraFile.tanpura1(
      {required String name,
      required String path,
      required Scale originalScale,
      required bool isSelected}) {
    return TanpuraFile(
        instrument: Instruments.tanpura1,
        name: name,
        path: path,
        originalScale: originalScale,
        isSelected: isSelected);
  }
  factory TanpuraFile.tanpura2(
      {required String name,
      required String path,
      required Scale originalScale,
      required bool isSelected}) {
    return TanpuraFile(
        instrument: Instruments.tanpura2,
        name: name,
        path: path,
        originalScale: originalScale,
        isSelected: isSelected);
  }
  InstrumentFile copyWith({
    Instruments? instrument,
    String? name,
    String? path,
    Scale? originalScale,
    bool? isSelected,
  }) {
    return TanpuraFile(
      instrument: instrument ?? this.instrument,
      name: name ?? this.name,
      path: path ?? this.path,
      originalScale: originalScale ?? this.originalScale,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool noteInRange(MusicNote note) {
    return note == originalScale.note;
  }
}
