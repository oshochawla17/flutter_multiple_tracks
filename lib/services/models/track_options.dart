import 'package:equatable/equatable.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

class TrackOptions extends Equatable {
  const TrackOptions({
    required this.volume,
    required this.isMute,
    this.isTrackOn = true,
    this.useGlobalPitch = true,
    this.useGlobalTempo = true,
    this.tempo,
    this.pitch,
  });

  final double volume;
  final bool isMute;
  final bool isTrackOn;
  final bool useGlobalPitch;
  final bool useGlobalTempo;
  final int? tempo;
  final int? pitch;

  static const int defaultPitch = 0;
  static const MusicNote defaultNote = MusicNote.E;
  static const int minPitch = -99;
  static const int maxPitch = 99;
  static const int defaultTempo = 60;
  static const int minTempo = 15;
  static const int maxTempo = 500;

  TrackOptions copyWith({
    double? volume,
    bool? isMute,
    bool? isTrackOn,
    bool? useGlobalPitch,
    bool? useGlobalTempo,
    int? pitch,
    int? tempo,
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
