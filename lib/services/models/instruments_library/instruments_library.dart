import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';

abstract class InstrumentLibrary {
  Instruments get instrument;
  List<InstrumentFile> get files;
}
