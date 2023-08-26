import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:flutter_multiple_tracks/widgets/scale_selector.dart';
import 'package:provider/provider.dart';

class ScaleTuner extends StatelessWidget {
  const ScaleTuner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalOptionsProvider>(builder: (context, provider, child) {
      onPitchChange(int value) {
        var provider = context.read<GlobalOptionsProvider>();
        var newOptions = provider.options.copyWith(pitch: value);
        provider.updateOptions(newOptions);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          context.read<GlobalTrackStatus>().setPitch(newOptions);
        });
      }

      return SliderTheme(
        data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
        child: Container(
          height: 170,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scale',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      const ScaleSelector(),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 55,
                        child: ClickableText(
                          number: provider.options.pitch,
                          max: TrackOptions.maxPitch,
                          min: TrackOptions.minPitch,
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
                            onPitchChange(tryParse);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: provider.options.pitch.toDouble(),
                      label: provider.options.pitch.toString(),
                      max: TrackOptions.maxPitch.toDouble(),
                      min: TrackOptions.minPitch.toDouble(),
                      onChanged: (double value) {
                        context.read<GlobalOptionsProvider>().updateOptions(
                            context
                                .read<GlobalOptionsProvider>()
                                .options
                                .copyWith(pitch: value.toInt()));
                        onPitchChange(value.toInt());
                      },
                      onChangeEnd: (double value) {},
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(TrackOptions.maxPitch.toString()),
                      Text(TrackOptions.minPitch.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
