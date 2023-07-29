import 'package:equatable/equatable.dart';

class SoundBlendGlobalOptions extends Equatable {
  final double pitch;
  final double tempo;
  final bool isMasterPlaying;

  const SoundBlendGlobalOptions(
      {required this.pitch, required this.tempo, this.isMasterPlaying = false});
  SoundBlendGlobalOptions copyWith({
    double? pitch,
    double? tempo,
    bool? isMasterPlaying,
  }) {
    return SoundBlendGlobalOptions(
      pitch: pitch ?? this.pitch,
      tempo: tempo ?? this.tempo,
      isMasterPlaying: isMasterPlaying ?? this.isMasterPlaying,
    );
  }

  @override
  List<Object?> get props => [pitch, tempo, isMasterPlaying];
}
