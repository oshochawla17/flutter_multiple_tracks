import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tanpura_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class TanpuraLibrary implements InstrumentLibrary {
  TanpuraLibrary({required this.instrument, required this.files});
  factory TanpuraLibrary.tanpura1({required List<TanpuraFile> files}) {
    return TanpuraLibrary(files: files, instrument: Instruments.tanpura1);
  }
  factory TanpuraLibrary.tanpura2({required List<TanpuraFile> files}) {
    return TanpuraLibrary(files: files, instrument: Instruments.tanpura2);
  }
  @override
  final Instruments instrument;

  @override
  final List<TanpuraFile> files;
}
