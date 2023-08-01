import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class VolumeBar extends StatelessWidget {
  const VolumeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackPlaylistsStatus>(builder: (context, provider, child) {
      return SliderTheme(
        data: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Row(
          children: [
            InkWell(
              child: Icon(
                  provider.options.isMute
                      ? Icons.volume_off
                      : Icons.volume_down,
                  color: provider.options.isMute
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.grey),
              onTap: () {
                provider.options.isMute
                    ? context.read<TrackPlaylistsStatus>().unmute()
                    : context.read<TrackPlaylistsStatus>().mute();
              },
            ),
            Slider(
              value: provider.options.volume,
              max: 1.00,
              min: 0.00,
              onChanged: (double value) {
                context.read<TrackPlaylistsStatus>().setVolume(value);
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
                context.read<TrackPlaylistsStatus>().setVolume(1);
              },
            ),
          ],
        ),
      );
    });
  }
}
