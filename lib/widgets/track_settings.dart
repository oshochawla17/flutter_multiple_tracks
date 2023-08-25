import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:provider/provider.dart';

class TrackSettings extends StatefulWidget {
  const TrackSettings({
    super.key,
  });
  @override
  State<TrackSettings> createState() => _TrackSettingsState();
}

class _TrackSettingsState extends State<TrackSettings> {
  bool isTrackOn = true;
  bool useGlobalPitch = true;
  bool useGlobalTempo = true;
  late int? pitch;
  late int? tempo;

  @override
  void initState() {
    final trackOptionsProvider = context.read<InstrumentTrack>();
    isTrackOn = trackOptionsProvider.trackOptions.isTrackOn;
    useGlobalPitch = trackOptionsProvider.trackOptions.useGlobalPitch;
    useGlobalTempo = trackOptionsProvider.trackOptions.useGlobalTempo;
    pitch = trackOptionsProvider.trackOptions.pitch;
    tempo = trackOptionsProvider.trackOptions.tempo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onPitchChange(pitch) {
      final providerVal = context.read<InstrumentTrack>();

      var newUseGlobalPitch = useGlobalPitch;
      if (newUseGlobalPitch) {
        // set pitch to global pitch value
        var globalOptionsProvider = context.read<GlobalOptionsProvider>();
        providerVal.setPitch(globalOptionsProvider.options.pitch);
      } else {
        // set pitch to default
        providerVal.setPitch(pitch);
      }
      providerVal.updateFromLocal(
        TrackOptions(
          volume: providerVal.trackOptions.volume,
          isMute: providerVal.trackOptions.isMute,
          isTrackOn: isTrackOn,
          useGlobalPitch: useGlobalPitch,
          useGlobalTempo: useGlobalTempo,
          pitch: pitch,
          tempo: tempo,
        ),
      );
    }

    onTempoChange(tempo) {
      final providerVal = context.read<InstrumentTrack>();
      var newTempo = useGlobalTempo;
      var globalOptionsProvider = context.read<GlobalOptionsProvider>();
      if (newTempo) {
        providerVal.updateFromGlobal(globalOptionsProvider.options);
      } else {
        providerVal.updateFromGlobal(
          globalOptionsProvider.options.copyWith(tempo: tempo),
        );
      }
      providerVal.updateFromLocal(
        TrackOptions(
          volume: providerVal.trackOptions.volume,
          isMute: providerVal.trackOptions.isMute,
          isTrackOn: isTrackOn,
          useGlobalPitch: useGlobalPitch,
          useGlobalTempo: useGlobalTempo,
          pitch: pitch,
          tempo: tempo,
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () {
                int defaultTempo = TrackOptions.defaultTempo;
                int defaultPitch = TrackOptions.defaultPitch;
                setState(() {
                  pitch = defaultPitch;
                  tempo = defaultTempo;
                });
                onPitchChange(defaultPitch);
                onTempoChange(defaultTempo);
              },
              child: const Icon(Icons.replay_outlined),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (pitch != null)
                  Row(
                    children: [
                      const SizedBox(width: 55, child: Text('Pitch:')),
                      Container(
                        width: 60,
                        padding: const EdgeInsets.only(left: 5),
                        child: ClickableText(
                          number: pitch!,
                          min: TrackOptions.minPitch,
                          max: TrackOptions.maxPitch,
                          formatText: (String text) {
                            var val = double.tryParse(text)!.toStringAsFixed(2);
                            if (val.endsWith('.00')) {
                              return val.substring(0, val.length - 3);
                            } else {
                              return val;
                            }
                          },
                          onValueChanged: (value) {
                            var tryParse = int.tryParse(value);
                            if (tryParse == null) return;
                            if (tryParse > TrackOptions.maxPitch) {
                              tryParse = TrackOptions.maxPitch;
                            }
                            if (tryParse < TrackOptions.minPitch) {
                              tryParse = TrackOptions.minPitch;
                            }

                            setState(() {
                              pitch = tryParse!;
                            });
                            onPitchChange(tryParse);
                          },
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: pitch!.toDouble(),
                          label: pitch.toString(),
                          min: TrackOptions.minPitch.toDouble(),
                          max: TrackOptions.maxPitch.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              pitch = value.toInt();
                            });
                            onPitchChange(pitch);
                          },
                        ),
                      )
                    ],
                  ),
                if (tempo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 55, child: Text('BPM:')),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.only(left: 5),
                          child: ClickableText(
                              number: tempo!,
                              min: TrackOptions.minTempo,
                              max: TrackOptions.maxTempo,
                              formatText: (String text) {
                                // if it's an integer use, that otherwise truncate to 2 digits
                                var percentage =
                                    double.tryParse(text)!.toStringAsFixed(2);
                                if (percentage.endsWith('.00')) {
                                  return percentage.substring(
                                      0, percentage.length - 3);
                                } else {
                                  return '$percentage%';
                                }
                              },
                              onValueChanged: (value) {
                                var tryParse = int.tryParse(value);
                                if (tryParse == null) return;
                                if (tryParse > TrackOptions.maxTempo) {
                                  tryParse = TrackOptions.maxTempo;
                                }
                                if (tryParse < TrackOptions.minTempo) {
                                  tryParse = TrackOptions.minTempo;
                                }
                                onTempoChange(tryParse);
                                setState(() {
                                  tempo = tryParse!;
                                });
                              }),
                        ),
                        Expanded(
                          child: Slider(
                            value: tempo!.toDouble(),
                            label: tempo!.toStringAsFixed(0),
                            max: TrackOptions.maxTempo.toDouble(),
                            min: TrackOptions.minTempo.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                tempo = value.toInt();
                              });
                              onTempoChange(tempo);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Use global pitch:'),
                Checkbox(
                    value: useGlobalPitch,
                    onChanged: (value) {
                      setState(() {
                        useGlobalPitch = value!;
                      });
                      onPitchChange(pitch);
                    }),
              ],
            ),
            Row(
              children: [
                const Text('Use global tempo:'),
                Checkbox(
                    value: useGlobalTempo,
                    onChanged: (value) {
                      setState(() {
                        useGlobalTempo = value!;
                      });
                      onTempoChange(tempo);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
