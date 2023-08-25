import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/metronome_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class MetronomeLibrary extends InstrumentLibrary {
  MetronomeLibrary({
    required this.taalFiles,
  });

  @override
  final Instruments instrument = Instruments.metronome;

  final Map<String, List<MetronomeFile>> taalFiles;

  @override
  List<MetronomeFile> get files {
    return taalFiles.values.expand((element) => element).toList();
  }
}
