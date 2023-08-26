import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';

class InstrumentsPlayingStatusProvider with ChangeNotifier {
  Map<Instruments, bool> statuses = {};
  updateStatuses(Map<Instruments, bool> status) {
    statuses = status;
    notifyListeners();
  }

  updateInstrumentStatus(Instruments instrument, bool status) {
    statuses[instrument] = status;
    notifyListeners();
  }

  bool isPlaying() {
    for (var instrument in statuses.values) {
      if (instrument) {
        return true;
      }
    }
    return false;
  }
}
