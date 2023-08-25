import 'package:equatable/equatable.dart';

class Scale extends Equatable {
  const Scale({required this.note, this.octave, this.isOpen = false});

  final MusicNote note;
  final int? octave;
  final bool isOpen;

  factory Scale.fromString(String scale) {
    bool isOpen = false;
    RegExp regex = RegExp(r'([A-Za-z#]+)(\d*)');
    if (scale.contains('open')) {
      isOpen = true;
      scale = scale.replaceAll('open', '');
    }
    RegExpMatch? match = regex.firstMatch(scale);

    if (match != null) {
      String note = match.group(1)!;
      MusicNote musicNote = MusicNote.values.firstWhere(
        (element) => element.name() == note,
      );

      String? octaveStr = match.group(2);
      int? octave;
      if (octaveStr != null && octaveStr.isNotEmpty) {
        octave = int.parse(octaveStr);
      }

      return Scale(note: musicNote, octave: octave, isOpen: isOpen);
    }
    throw Exception('Invalid scale');
  }

  @override
  String toString() {
    String scale = note.name();
    if (octave != null) {
      scale += octave.toString();
    }
    if (isOpen) {
      scale += 'open';
    }
    return scale;
  }

  Scale subtract(int note) {
    int currentNoteIndex = MusicNote.values.indexOf(this.note);
    int currentOctave = octave ?? 3;
    // B2, C3, C#3, D3, D#3, E3, F3, F#3, G3, G#3, A3, A#3, B3, C4, C#4, D4, D#4, E4, F4, F#4, G4, G#4, A4, A#4, B4, C5, C#5, D5, D#5, E5, F5, F#5, G5, G#5, A5, A#5, B5
    MusicNote newNote =
        MusicNote.values[(currentNoteIndex - note) % MusicNote.values.length];
    int newOctave =
        currentNoteIndex - note < 0 ? currentOctave - 1 : currentOctave;
    return Scale(note: newNote, octave: newOctave);
  }

  @override
  List<Object?> get props => [note, octave];
}

enum MusicNote {
  C,
  CSharp,
  D,
  DSharp,
  E,
  F,
  FSharp,
  G,
  GSharp,
  A,
  ASharp,
  B,
}

// c -> b
extension MusicScaleExt on MusicNote {
  String name() {
    switch (this) {
      case MusicNote.C:
        return 'C';
      case MusicNote.CSharp:
        return 'C#';
      case MusicNote.D:
        return 'D';
      case MusicNote.DSharp:
        return 'D#';
      case MusicNote.E:
        return 'E';
      case MusicNote.F:
        return 'F';
      case MusicNote.FSharp:
        return 'F#';
      case MusicNote.G:
        return 'G';
      case MusicNote.GSharp:
        return 'G#';
      case MusicNote.A:
        return 'A';
      case MusicNote.ASharp:
        return 'A#';
      case MusicNote.B:
        return 'B';
    }
  }
}
