import 'package:equatable/equatable.dart';

class SoundBlendGlobalOptions extends Equatable {
  final double pitch;
  final double tempo;
  final bool isMasterPlaying;

  const SoundBlendGlobalOptions(
      {required this.pitch, required this.tempo, this.isMasterPlaying = false});

  @override
  List<Object?> get props => [pitch, tempo, isMasterPlaying];
}
