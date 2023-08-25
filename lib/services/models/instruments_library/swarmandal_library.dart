import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/swarmandal_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class SwarmandalLibrary extends InstrumentLibrary {
  SwarmandalLibrary({
    required this.raagFiles,
  });

  @override
  final Instruments instrument = Instruments.swarmandal;

  @override
  List<SwarmandalFile> get files {
    return raagFiles.values.expand((element) => element).toList();
  }

  final Map<String, List<SwarmandalFile>> raagFiles;
}
