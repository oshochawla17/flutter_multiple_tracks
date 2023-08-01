import 'package:equatable/equatable.dart';

class TrackOptions extends Equatable {
  final double volume;
  final bool isMute;
  final bool isTrackOn;
  final bool useGlobalPitch;
  final bool useGlobalTempo;
  final double tempo;
  final double pitch;

  const TrackOptions({
    required this.volume,
    required this.isMute,
    required this.isTrackOn,
    required this.useGlobalPitch,
    required this.useGlobalTempo,
    required this.tempo,
    required this.pitch,
  });
  TrackOptions copyWith({
    double? volume,
    bool? isMute,
    bool? isTrackOn,
    bool? useGlobalPitch,
    bool? useGlobalTempo,
    double? pitch,
    double? tempo,
  }) {
    return TrackOptions(
      volume: volume ?? this.volume,
      isMute: isMute ?? this.isMute,
      isTrackOn: isTrackOn ?? this.isTrackOn,
      useGlobalPitch: useGlobalPitch ?? this.useGlobalPitch,
      useGlobalTempo: useGlobalTempo ?? this.useGlobalTempo,
      pitch: pitch ?? this.pitch,
      tempo: tempo ?? this.tempo,
    );
  }

  @override
  List<Object?> get props =>
      [volume, isTrackOn, useGlobalPitch, useGlobalTempo, isMute, pitch, tempo];
}
