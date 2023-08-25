import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:flutter_multiple_tracks/widgets/master_play_button.dart';
import 'package:flutter_multiple_tracks/widgets/scale_selector.dart';
import 'package:provider/provider.dart';

class MasterRow extends StatelessWidget {
  const MasterRow({super.key});

  @override
  Widget build(BuildContext context) {
    onPitchChange(int value) {
      var provider = context.read<GlobalOptionsProvider>();
      var newOptions = provider.options.copyWith(pitch: value);
      provider.updateOptions(newOptions);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<GlobalTrackStatus>().setPitch(newOptions);
      });
    }

    onTempoChange(int bpm) {
      var optionsProvider = context.read<GlobalOptionsProvider>();
      var newOptions = optionsProvider.options.copyWith(tempo: bpm);
      optionsProvider.updateOptions(newOptions);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<GlobalTrackStatus>().setTempo(newOptions);
      });
    }

    return Consumer<GlobalOptionsProvider>(builder: (context, provider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              int defaultTempo = TrackOptions.defaultTempo;
              int defaultPitch = TrackOptions.defaultPitch;
              MusicNote defaultNote = TrackOptions.defaultNote;
              var optionsProvider = context.read<GlobalOptionsProvider>();
              var newOptions = optionsProvider.options.copyWith(
                tempo: defaultTempo,
                pitch: defaultPitch,
                note: defaultNote,
              );
              optionsProvider.updateOptions(
                newOptions,
              );
              context.read<GlobalTrackStatus>().setTempo(newOptions);
              // context.read<GlobalTrackStatus>().setPitch(newOptions);
            },
            child: const Icon(Icons.replay_outlined),
          ),
          const ScaleSelector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        const SizedBox(width: 55, child: Text('Pitch:')),
                        SizedBox(
                          width: 100,
                          child: ClickableText(
                            number: provider.options.pitch,
                            max: TrackOptions.maxPitch,
                            min: TrackOptions.minPitch,
                            formatText: (String text) {
                              var val =
                                  double.tryParse(text)!.toStringAsFixed(2);
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
                              onPitchChange(tryParse);
                            },
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: provider.options.pitch.toDouble(),
                            label: provider.options.pitch.toString(),
                            max: TrackOptions.maxPitch.toDouble(),
                            min: TrackOptions.minPitch.toDouble(),
                            onChanged: (double value) {
                              context
                                  .read<GlobalOptionsProvider>()
                                  .updateOptions(context
                                      .read<GlobalOptionsProvider>()
                                      .options
                                      .copyWith(pitch: value.toInt()));
                            },
                            onChangeEnd: (double value) {
                              onPitchChange(value.toInt());
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 55, child: Text('BPM:')),
                          SizedBox(
                              width: 100,
                              child: ClickableText(
                                number: provider.options.tempo,
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
                                    return percentage;
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
                                },
                              )),
                          Expanded(
                            child: Slider(
                              value: provider.options.tempo.toDouble(),
                              label:
                                  (provider.options.tempo).toStringAsFixed(0),
                              max: TrackOptions.maxTempo.toDouble(),
                              min: TrackOptions.minTempo.toDouble(),
                              onChanged: (double value) {
                                context
                                    .read<GlobalOptionsProvider>()
                                    .updateOptions(context
                                        .read<GlobalOptionsProvider>()
                                        .options
                                        .copyWith(tempo: value.toInt()));
                              },
                              onChangeEnd: (double value) {
                                var newOptions = provider.options
                                    .copyWith(tempo: value.toInt());
                                provider.updateOptions(newOptions);
                                context
                                    .read<GlobalTrackStatus>()
                                    .setTempo(newOptions);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const MasterPlayButton(),
            ],
          ),
        ],
      );
    });
  }
}
