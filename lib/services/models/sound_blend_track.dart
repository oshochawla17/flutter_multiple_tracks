import 'package:flutter_multiple_tracks/services/models/sound_blend_player.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_sound_state.dart';

class SoundBlendTrack {
  final List<SoundBlendPlayer> players;
  final SoundBlendSoundState soundState;
  final bool isTrackOn;
  final bool useGlobalPitch;
  final bool useGlobalTempo;

  const SoundBlendTrack({
    required this.players,
    required this.soundState,
    required this.isTrackOn,
    required this.useGlobalPitch,
    required this.useGlobalTempo,
  });
}
