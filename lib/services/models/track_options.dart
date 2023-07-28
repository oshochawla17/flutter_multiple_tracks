import 'package:equatable/equatable.dart';

class TrackOptions extends Equatable {
  final double volume;
  final bool isTrackOn;
  final bool useGlobalPitch;
  final bool useGlobalTempo;

  const TrackOptions(
      {required this.volume,
      required this.isTrackOn,
      required this.useGlobalPitch,
      required this.useGlobalTempo});
  TrackOptions copyWith({
    double? volume,
    bool? isTrackOn,
    bool? useGlobalPitch,
    bool? useGlobalTempo,
  }) {
    return TrackOptions(
      volume: volume ?? this.volume,
      isTrackOn: isTrackOn ?? this.isTrackOn,
      useGlobalPitch: useGlobalPitch ?? this.useGlobalPitch,
      useGlobalTempo: useGlobalTempo ?? this.useGlobalTempo,
    );
  }

  @override
  List<Object?> get props =>
      [volume, isTrackOn, useGlobalPitch, useGlobalTempo];
}
