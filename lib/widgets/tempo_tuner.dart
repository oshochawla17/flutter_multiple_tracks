import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:provider/provider.dart';

class TempoTuner extends StatelessWidget {
  const TempoTuner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalOptionsProvider>(builder: (context, provider, child) {
      onTempoChange(int bpm) {
        var optionsProvider = context.read<GlobalOptionsProvider>();
        var newOptions = optionsProvider.options.copyWith(tempo: bpm);
        optionsProvider.updateOptions(newOptions);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          context.read<GlobalTrackStatus>().setTempo(newOptions);
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 27,
                        width: 27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              var newVal = provider.options.tempo + 1;
                              if (newVal > TrackOptions.maxTempo) return;

                              context
                                  .read<GlobalOptionsProvider>()
                                  .updateOptions(context
                                      .read<GlobalOptionsProvider>()
                                      .options
                                      .copyWith(
                                          tempo: provider.options.tempo + 1));
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                      Container(
                        height: 27,
                        width: 27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              var newVal = provider.options.tempo - 1;
                              if (newVal < TrackOptions.minTempo) return;
                              context
                                  .read<GlobalOptionsProvider>()
                                  .updateOptions(context
                                      .read<GlobalOptionsProvider>()
                                      .options
                                      .copyWith(
                                          tempo: provider.options.tempo - 1));
                            },
                            child: const Icon(Icons.remove),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      value: provider.options.tempo.toDouble(),
                      label: (provider.options.tempo).toStringAsFixed(0),
                      max: TrackOptions.maxTempo.toDouble(),
                      min: TrackOptions.minTempo.toDouble(),
                      onChanged: (double value) {
                        context.read<GlobalOptionsProvider>().updateOptions(
                            context
                                .read<GlobalOptionsProvider>()
                                .options
                                .copyWith(tempo: value.toInt()));
                      },
                      onChangeEnd: (double value) {
                        var newOptions =
                            provider.options.copyWith(tempo: value.toInt());
                        provider.updateOptions(newOptions);
                        context.read<GlobalTrackStatus>().setTempo(newOptions);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 27,
                        width: 27,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              var newVal = provider.options.tempo + 5;
                              if (newVal > TrackOptions.maxTempo) {
                                newVal = TrackOptions.maxTempo;
                              }
                              context
                                  .read<GlobalOptionsProvider>()
                                  .updateOptions(context
                                      .read<GlobalOptionsProvider>()
                                      .options
                                      .copyWith(tempo: newVal));
                            },
                            child: const Text('+5',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Container(
                        height: 27,
                        width: 27,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              var newVal = provider.options.tempo - 5;
                              if (newVal < TrackOptions.minTempo) {
                                newVal = TrackOptions.minTempo;
                              }

                              context
                                  .read<GlobalOptionsProvider>()
                                  .updateOptions(context
                                      .read<GlobalOptionsProvider>()
                                      .options
                                      .copyWith(tempo: newVal));
                            },
                            child: const Text('-5',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tempo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClickableText(
                      number: provider.options.tempo,
                      min: TrackOptions.minTempo,
                      max: TrackOptions.maxTempo,
                      formatText: (String text) {
                        var percentage =
                            double.tryParse(text)!.toStringAsFixed(2);
                        if (percentage.endsWith('.00')) {
                          return percentage.substring(0, percentage.length - 3);
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
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    'BPM',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
