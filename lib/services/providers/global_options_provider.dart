import 'package:flutter/foundation.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';

class GlobalOptionsProvider extends ChangeNotifier {
  SoundBlendGlobalOptions options = const SoundBlendGlobalOptions(
    pitch: 0,
    tempo: 1.0,
    isMasterPlaying: false,
  );
  void updateOptions(SoundBlendGlobalOptions options) {
    this.options = options;
    notifyListeners();
  }
}
