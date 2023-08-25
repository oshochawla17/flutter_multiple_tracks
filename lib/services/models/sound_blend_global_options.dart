import 'package:equatable/equatable.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class SoundBlendGlobalOptions extends Equatable {
  final int pitch;
  final int tempo;
  final MusicNote note;
  final bool isMasterPlaying;
  final String? selectedTaal;

  const SoundBlendGlobalOptions(
      {required this.pitch,
      required this.tempo,
      required this.note,
      this.selectedTaal,
      this.isMasterPlaying = false});
  SoundBlendGlobalOptions copyWith({
    int? pitch,
    int? tempo,
    MusicNote? note,
    bool? isMasterPlaying,
    String? selectedTaal,
  }) {
    return SoundBlendGlobalOptions(
      pitch: pitch ?? this.pitch,
      tempo: tempo ?? this.tempo,
      note: note ?? this.note,
      isMasterPlaying: isMasterPlaying ?? this.isMasterPlaying,
      selectedTaal: selectedTaal ?? this.selectedTaal,
    );
  }

  @override
  List<Object?> get props => [pitch, tempo, note, isMasterPlaying];
}
