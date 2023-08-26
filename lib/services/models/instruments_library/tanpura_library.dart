import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tanpura_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';

class TanpuraLibrary extends InstrumentLibrary {
  TanpuraLibrary({
    // required this.instrument,
    required this.subfiles,
  });

  // TanpuraLibrary.tanpura1({required this.subfiles})
  //     : instrument = Instruments.tanpura1;

  // TanpuraLibrary.tanpura2({
  //   required this.subfiles,
  // }) : instrument = Instruments.tanpura2;

  // @override
  // final Instruments instrument;

  @override
  List<TanpuraFile> get files {
    return subfiles.values.expand((element) => element).toList();
  }

  final Map<String, List<TanpuraFile>> subfiles;
}
