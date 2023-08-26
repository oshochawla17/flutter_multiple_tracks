import 'package:flutter_multiple_tracks/services/models/track_options.dart';

class SwarmandalTrackOptions extends TrackOptions {
  const SwarmandalTrackOptions({
    this.useRandomInterval = false,
    this.randomIntervalsRange = const [5, 12],
    this.interval = 3,
    super.volume = 1.0,
    super.isMute = false,
    super.isTrackOn = true,
    super.useGlobalPitch = true,
    super.useGlobalTempo = false,
    super.tempo = TrackOptions.defaultPitch,
    super.pitch = TrackOptions.defaultPitch,
  });
  final bool useRandomInterval;
  final List<int> randomIntervalsRange;
  final int? interval;

  SwarmandalTrackOptions deepCopy() {
    return SwarmandalTrackOptions(
      useRandomInterval: useRandomInterval,
      randomIntervalsRange: randomIntervalsRange,
      interval: interval,
      volume: volume,
      isMute: isMute,
      isTrackOn: isTrackOn,
      useGlobalPitch: useGlobalPitch,
      useGlobalTempo: useGlobalTempo,
      tempo: tempo,
      pitch: pitch,
    );
  }

  SwarmandalTrackOptions copyWith({
    bool? useRandomInterval,
    List<int>? randomIntervalsRange,
    int? interval,
    double? volume,
    bool? isMute,
    bool? isTrackOn,
    bool? useGlobalPitch,
    bool? useGlobalTempo,
    int? tempo,
    int? pitch,
  }) {
    return SwarmandalTrackOptions(
      useRandomInterval: useRandomInterval ?? this.useRandomInterval,
      randomIntervalsRange: randomIntervalsRange ?? this.randomIntervalsRange,
      interval: interval ?? this.interval,
      volume: volume ?? this.volume,
      isMute: isMute ?? this.isMute,
      isTrackOn: isTrackOn ?? this.isTrackOn,
      useGlobalPitch: useGlobalPitch ?? this.useGlobalPitch,
      useGlobalTempo: useGlobalTempo ?? this.useGlobalTempo,
      tempo: tempo ?? this.tempo,
      pitch: pitch ?? this.pitch,
    );
  }
}
