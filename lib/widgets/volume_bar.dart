import 'package:flutter/material.dart';
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
        child: Row(
          children: [
            InkWell(
              child: Icon(
                  provider.trackOptions.isMute
                      ? Icons.volume_off
                      : Icons.volume_down,
                  color: provider.trackOptions.isMute
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.grey),
              onTap: () {
                provider.trackOptions.isMute
                    ? context.read<InstrumentTrack>().unmute()
                    : context.read<InstrumentTrack>().mute();
              },
            ),
            Slider(
              value: provider.trackOptions.volume,
              max: 1.00,
              min: 0.00,
              onChanged: (double value) {
                context.read<InstrumentTrack>().setVolume(value);
              },
            ),
            InkWell(
              child: Icon(
                Icons.volume_up,
                color: provider.trackOptions.volume == 1
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.7),
              ),
              onTap: () {
                context.read<InstrumentTrack>().setVolume(1);
              },
            ),
          ],
        ),
      );
    });
  }
}
