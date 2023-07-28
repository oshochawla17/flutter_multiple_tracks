import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/track_options_provider.dart';
import 'package:provider/provider.dart';

class VolumeBar extends StatelessWidget {
  const VolumeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackOptionsProvider>(builder: (context, provider, child) {
      return SliderTheme(
        data: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Icon(
                  provider.options.volume == 0
                      ? Icons.volume_off
                      : Icons.volume_down,
                  color: provider.options.volume == 0
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.grey),
              onTap: () {
                context.read<TrackOptionsProvider>().setVolume(0);
              },
            ),
            Slider(
              value: provider.options.volume,
              max: 1.00,
              min: 0.00,
              onChanged: (double value) {
                context.read<TrackOptionsProvider>().setVolume(value);
              },
            ),
            InkWell(
              child: Icon(
                Icons.volume_up,
                color: provider.options.volume == 1
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.7),
              ),
              onTap: () {
                context.read<TrackOptionsProvider>().setVolume(1);
              },
            ),
          ],
        ),
      );
    });
  }
}
