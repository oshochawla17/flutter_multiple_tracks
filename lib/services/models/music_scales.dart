class Scale {
  final MusicNote note;
  final int? octave;
  Scale({required this.note, this.octave});
  factory Scale.fromString(String scale) {
    RegExp regex = RegExp(r'([A-Za-z#]+)(\d*)');
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

      return Scale(note: musicNote, octave: octave);
    }
    throw Exception('Invalid scale');
  }
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
