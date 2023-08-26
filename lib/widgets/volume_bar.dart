import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:provider/provider.dart';

class VolumeBar extends StatelessWidget {
  const VolumeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      return SliderTheme(
        data: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Column(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: provider.trackOptions.volume,
                max: 1.00,
                min: 0.00,
                onChanged: (double value) {
                  context.read<InstrumentTrack>().setVolume(value);
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              provider.instrument.instrumentName(),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    });
  }
}
