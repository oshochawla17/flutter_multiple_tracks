import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tanpura_track.dart';
import 'package:provider/provider.dart';

class TanpuraSlider extends StatelessWidget {
  const TanpuraSlider({super.key});

  @override
  Widget build(BuildContext context) {
    onTempoChange(int tempo) {
      final providerVal = context.read<InstrumentTrack>();

      providerVal.updateFromLocal(
        providerVal.trackOptions.copyWith(tempo: tempo),
      );
      providerVal as TanpuraTrack;
      providerVal
          .updateFromGlobal(context.read<GlobalOptionsProvider>().options);
    }

    const int minTempo = 30;
    const int maxTempo = 180;
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              provider.trackOptions.tempo.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                if (provider.trackOptions.tempo! > minTempo) {
                  onTempoChange(provider.trackOptions.tempo! - 1);
                }
              },
              child: const Center(child: Icon(Icons.remove))),
          const SizedBox(width: 10),
          Slider(
            value: provider.trackOptions.tempo!.toDouble(),
            min: 30,
            max: 180,
            onChanged: (double value) {
              provider.updateFromLocal(
                provider.trackOptions.copyWith(tempo: value.toInt()),
              );
            },
            onChangeEnd: (double value) {
              onTempoChange(value.toInt());
            },
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                if (provider.trackOptions.tempo! < maxTempo) {
                  onTempoChange(provider.trackOptions.tempo! + 1);
                }
              },
              child: const Center(child: Icon(Icons.add))),
        ],
      );
    });
  }
}
