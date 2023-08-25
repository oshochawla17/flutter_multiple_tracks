import 'package:flutter/foundation.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';

class GlobalOptionsProvider extends ChangeNotifier {
  SoundBlendGlobalOptions options = const SoundBlendGlobalOptions(
    pitch: TrackOptions.defaultPitch,
    tempo: TrackOptions.defaultTempo,
    isMasterPlaying: false,
    note: MusicNote.E,
  );
  void updateOptions(SoundBlendGlobalOptions options) {
    this.options = options;
    notifyListeners();
  }
}
