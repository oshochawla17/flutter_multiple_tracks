import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class MetronomeFile extends InstrumentFile {
  MetronomeFile({
    required this.name,
    required this.path,
    required this.subtype,
    required this.originalTempo,
    required this.tempoRange,
    required this.isSelected,
  });

  @override
  final Instruments instrument = Instruments.metronome;

  @override
  final String name;

  @override
  final String path;

  @override
  final bool isSelected;

  final String subtype;

  final int originalTempo;

  final List<int> tempoRange;

  @override
  InstrumentFile copyWith({
    Instruments? instrument,
    String? name,
    String? path,
    Scale? originalScale,
    bool? isSelected,
  }) {
    return MetronomeFile(
      name: name ?? this.name,
      path: path ?? this.path,
      subtype: subtype,
      originalTempo: originalTempo,
      tempoRange: tempoRange,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool tempoInRange(int tempo) {
    return tempo == originalTempo ||
        (tempoRange[0] <= tempo && tempo <= tempoRange[1]);
  }
}
