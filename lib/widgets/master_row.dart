import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:flutter_multiple_tracks/widgets/master_play_button.dart';
import 'package:provider/provider.dart';

class MasterRow extends StatelessWidget {
  const MasterRow({super.key});

  @override
  Widget build(BuildContext context) {
    onPitchChange(double value) {
      context.read<GlobalOptionsProvider>().updateOptions(
          context.read<GlobalOptionsProvider>().options.copyWith(pitch: value));
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<GlobalTrackStatus>().setPitch(value);
      });
    }

    onTempoChange(double value) {
      context.read<GlobalOptionsProvider>().updateOptions(
          context.read<GlobalOptionsProvider>().options.copyWith(tempo: value));
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<GlobalTrackStatus>().setTempo(value);
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
              double defaultTempo = 1.0;
              double defaultPitch = 0;
              context.read<GlobalOptionsProvider>().updateOptions(
                    SoundBlendGlobalOptions(
                      tempo: defaultTempo,
                      pitch: defaultPitch,
                    ),
                  );

              context.read<GlobalTrackStatus>().setPitch(defaultPitch);
              context.read<GlobalTrackStatus>().setTempo(defaultTempo);
            },
            child: const Icon(Icons.replay_outlined),
          ),
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
                            min: -12,
                            max: 12,
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
                              var tryParse = double.tryParse(value);
                              if (tryParse == null) return;
                              if (tryParse > 12) tryParse = 12;
                              if (tryParse < -12) tryParse = -12;
                              onPitchChange(tryParse);
                            },
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: provider.options.pitch.toDouble(),
                            label: provider.options.pitch.toString(),
                            max: 12.00,
                            min: -12.00,
                            onChanged: (double value) {
                              onPitchChange(value);
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
                          SizedBox(
                              width: 100,
                              child: ClickableText(
                                number: provider.options.tempo * 100,
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
                                },
                              )),
                          Expanded(
                            child: Slider(
                              value: provider.options.tempo,
                              label:
                                  '${(provider.options.tempo * 100).toStringAsFixed(0)}%',
                              max: 2,
                              min: 0.5,
                              onChanged: (double value) {
                                context
                                    .read<GlobalOptionsProvider>()
                                    .updateOptions(context
                                        .read<GlobalOptionsProvider>()
                                        .options
                                        .copyWith(tempo: value));
                                context
                                    .read<GlobalTrackStatus>()
                                    .setTempo(value);
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
