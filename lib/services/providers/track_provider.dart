import 'package:flutter/foundation.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';

class TrackProvider extends ChangeNotifier {
  TrackOptions options = const TrackOptions(
    isTrackOn: true,
    useGlobalPitch: true,
    useGlobalTempo: true,
    volume: 0.5,
  );

  void setVolume(double volume) {
    options = options.copyWith(volume: volume);
  }

  void updateOptions(TrackOptions options) {
    this.options = options;
    notifyListeners();
  }
}