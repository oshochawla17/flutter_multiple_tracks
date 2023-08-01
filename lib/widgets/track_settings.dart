import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
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
  late double pitch;
  late double tempo;

  @override
  void initState() {
    final trackOptionsProvider = context.read<TrackPlaylistsStatus>();
    isTrackOn = trackOptionsProvider.options.isTrackOn;
    useGlobalPitch = trackOptionsProvider.options.useGlobalPitch;
    useGlobalTempo = trackOptionsProvider.options.useGlobalTempo;
    pitch = trackOptionsProvider.options.pitch;
    tempo = trackOptionsProvider.options.tempo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onPitchChange(pitch) {
      final providerVal = context.read<TrackPlaylistsStatus>();

      var newUseGlobalPitch = useGlobalPitch;
      if (newUseGlobalPitch) {
        // set pitch to global pitch value
        var globalOptionsProvider = context.read<GlobalOptionsProvider>();
        providerVal.setPitch(globalOptionsProvider.options.pitch);
      } else {
        // set pitch to default
        providerVal.setPitch(pitch);
      }
      providerVal.updateOptions(
        TrackOptions(
          volume: providerVal.options.volume,
          isMute: providerVal.options.isMute,
          isTrackOn: isTrackOn,
          useGlobalPitch: useGlobalPitch,
          useGlobalTempo: useGlobalTempo,
          pitch: pitch,
          tempo: tempo,
        ),
      );
    }

    onTempoChange(tempo) {
      final providerVal = context.read<TrackPlaylistsStatus>();
      var newTempo = useGlobalTempo;
      if (newTempo) {
        // set tempo to global tempo value
        var globalOptionsProvider = context.read<GlobalOptionsProvider>();
        providerVal.setTempo(globalOptionsProvider.options.tempo);
      } else {
        // set tempo to default
        providerVal.setTempo(tempo);
      }
      providerVal.updateOptions(
        TrackOptions(
          volume: providerVal.options.volume,
          isMute: providerVal.options.isMute,
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
                double defaultTempo = 1.0;
                double defaultPitch = 0;
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
                Row(
                  children: [
                    const SizedBox(width: 55, child: Text('Pitch:')),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.only(left: 5),
                      child: ClickableText(
                        number: pitch,
                        min: -12,
                        max: 12,
                        formatText: (String text) {
                          var val = double.tryParse(text)!.toStringAsFixed(2);
                          if (val.endsWith('.00')) {
                            return val.substring(0, val.length - 3);
                          } else {
                            return val;
                          }
                        },
                        onValueChanged: (value) {
                          var tryParse = double.tryParse(value);
                          if (tryParse == null) return;
                          if (tryParse > 12) tryParse = 12;
                          if (tryParse < -12) tryParse = -12;
                          setState(() {
                            pitch = tryParse!;
                          });
                          onPitchChange(tryParse);
                        },
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: pitch.toDouble(),
                        label: pitch.toString(),
                        max: 12.00,
                        min: -12.00,
                        onChanged: (double value) {
                          setState(() {
                            pitch = value;
                          });
                          onPitchChange(pitch);
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 55, child: Text('Tempo:')),
                      Container(
                        width: 60,
                        padding: const EdgeInsets.only(left: 5),
                        child: ClickableText(
                            number: tempo * 100,
                            min: 50,
                            max: 200,
                            formatText: (String text) {
                              // if it's an integer use, that otherwise truncate to 2 digits
                              var percentage =
                                  double.tryParse(text)!.toStringAsFixed(2);
                              if (percentage.endsWith('.00')) {
                                return '${percentage.substring(0, percentage.length - 3)}%';
                              } else {
                                return '$percentage%';
                              }
                            },
                            onValueChanged: (value) {
                              var tryParse = double.tryParse(value);
                              if (tryParse == null) return;
                              if (tryParse > 200) tryParse = 200;
                              if (tryParse < 50) tryParse = 50;
                              onTempoChange(tryParse / 100);
                              setState(() {
                                tempo = tryParse! / 100;
                              });
                            }),
                      ),
                      Expanded(
                        child: Slider(
                          value: tempo,
                          label: '${(tempo * 100).toStringAsFixed(0)}%',
                          max: 2,
                          min: 0.5,
                          onChanged: (double value) {
                            setState(() {
                              tempo = value;
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
