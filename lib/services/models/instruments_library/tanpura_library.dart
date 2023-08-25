import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tanpura_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class TanpuraLibrary implements InstrumentLibrary {
  TanpuraLibrary({required this.files});

  @override
  final Instruments instrument = Instruments.tanpura;

  @override
  final List<TanpuraFile> files;
}
