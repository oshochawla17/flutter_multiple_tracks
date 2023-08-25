import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tabla_pakhawaj_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class TablaPakhawajLibrary extends InstrumentLibrary {
  TablaPakhawajLibrary({
    required this.instrument,
    required this.taalFiles,
  });

  TablaPakhawajLibrary.tabla({required this.taalFiles})
      : instrument = Instruments.tabla;

  TablaPakhawajLibrary.pakhawaj({
    required this.taalFiles,
  }) : instrument = Instruments.pakhawaj;

  @override
  final Instruments instrument;

  @override
  List<TablaPakhawajFile> get files {
    return taalFiles.values.expand((element) => element).toList();
  }

  final Map<String, List<TablaPakhawajFile>> taalFiles;
}
