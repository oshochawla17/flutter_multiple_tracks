import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class SwarmandalFile extends InstrumentFile {
  SwarmandalFile({
    required this.name,
    required this.path,
    required this.originalScale,
    required this.subtype,
    required this.scaleRange,
    required this.isSelected,
  });

  @override
  final Instruments instrument = Instruments.swarmandal;

  @override
  final String name;

  @override
  final String path;

  final Scale originalScale;
  @override
  final bool isSelected;

  final String subtype;

  final List<Scale> scaleRange;

  @override
  InstrumentFile copyWith({
    Instruments? instrument,
    String? name,
    String? path,
    Scale? originalScale,
    bool? isSelected,
  }) {
    return SwarmandalFile(
      name: name ?? this.name,
      path: path ?? this.path,
      originalScale: originalScale ?? this.originalScale,
      subtype: subtype,
      scaleRange: scaleRange,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool noteInRange(MusicNote note) {
    // 0 - 11
    // 1 - 3
    // note - 0
    if (note == originalScale.note) return true;
    var startIndex = scaleRange[0].note.index;
    var endIndex = scaleRange[1].note.index < startIndex
        ? 12 + scaleRange[1].note.index
        : scaleRange[1].note.index;
    var noteIndex = note.index < startIndex ? 12 + note.index : note.index;
    return startIndex <= noteIndex && noteIndex <= endIndex;
  }

  List<MusicNote> noteRange() {
    var startIndex = scaleRange[0].note.index;
    var endIndex = scaleRange[1].note.index < startIndex
        ? 12 + scaleRange[1].note.index
        : scaleRange[1].note.index;
    List<MusicNote> notes = [];
    for (var i = startIndex; i <= endIndex; i++) {
      notes.add(MusicNote.values[i % 12]);
    }
    return notes;
  }
}
