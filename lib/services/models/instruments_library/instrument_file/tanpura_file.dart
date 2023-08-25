import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class TanpuraFile extends InstrumentFile {
  TanpuraFile({
    required this.name,
    required this.path,
    required this.originalScale,
    this.isSelected = true,
  });

  @override
  final bool isSelected;

  @override
  final Instruments instrument = Instruments.tanpura;

  @override
  final String name;

  @override
  final String path;

  final Scale originalScale;

  InstrumentFile copyWith({
    String? name,
    String? path,
    Scale? originalScale,
    bool? isSelected,
  }) {
    return TanpuraFile(
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
