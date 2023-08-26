import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiple_tracks/services/models/swarmandal_track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:provider/provider.dart';

class SwarmandalSettings extends StatelessWidget {
  const SwarmandalSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<InstrumentTrack>(builder: (context, provider, child) {
        var trackOptions = provider.trackOptions as SwarmandalTrackOptions;
        return Container(
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
              Opacity(
                opacity: !trackOptions.useRandomInterval ? 1.0 : 0.5,
                child: AbsorbPointer(
                  absorbing: trackOptions.useRandomInterval,
                  child: SizedBox(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Gaps',
                      ),
                      initialValue: trackOptions.gaps.toString(),
                      onChanged: (value) {
                        var tryParse = int.tryParse(value);
                        if (tryParse == null) {
                          return;
                        }
                        provider.updateFromLocal(
                          trackOptions.copyWith(
                            gaps: int.parse(value),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('Use Random Intervals:'),
                  Checkbox(
                    value: trackOptions.useRandomInterval,
                    onChanged: (value) {
                      provider.updateFromLocal(
                        trackOptions.copyWith(
                          useRandomInterval: value,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Opacity(
                opacity: trackOptions.useRandomInterval ? 1.0 : 0.5,
                child: AbsorbPointer(
                  absorbing: !trackOptions.useRandomInterval,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Start',
                          ),
                          initialValue:
                              trackOptions.randomIntervalsRange[0].toString(),
                          onChanged: (value) {
                            var tryParse = int.tryParse(value);
                            if (tryParse == null) {
                              return;
                            }
                            provider.updateFromLocal(
                              trackOptions.copyWith(
                                randomIntervalsRange: [
                                  int.parse(value),
                                  trackOptions.randomIntervalsRange[1]
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            labelText: 'End',
                          ),
                          initialValue:
                              trackOptions.randomIntervalsRange[1].toString(),
                          onChanged: (value) {
                            var tryParse = int.tryParse(value);
                            if (tryParse == null) {
                              return;
                            }
                            provider.updateFromLocal(
                              trackOptions.copyWith(
                                randomIntervalsRange: [
                                  trackOptions.randomIntervalsRange[0],
                                  int.parse(value)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
