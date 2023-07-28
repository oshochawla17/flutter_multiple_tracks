import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/track_options_provider.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';
import 'package:flutter_multiple_tracks/widgets/track_settings.dart';
import 'package:flutter_multiple_tracks/widgets/volume_bar.dart';
import 'package:provider/provider.dart';

class TrackRow extends StatelessWidget {
  const TrackRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrackOptionsProvider>(
      create: (context) => TrackOptionsProvider(),
      child:
          Consumer<TrackOptionsProvider>(builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TrackPlayButton(),
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: VolumeBar(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.settings_outlined,
                      size: 30,
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext builderContext) {
                          final trackOptionsProvider =
                              context.read<TrackOptionsProvider>();
                          return ChangeNotifierProvider<
                              TrackOptionsProvider>.value(
                            value: trackOptionsProvider,
                            child: const TrackSettings(),
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: InkWell(
                      child: const Icon(
                        Icons.playlist_play,
                        size: 30,
                      ),
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext builderContext) {
                            final trackOptionsProvider =
                                context.read<TrackOptionsProvider>();
                            return ChangeNotifierProvider<
                                TrackOptionsProvider>.value(
                              value: trackOptionsProvider,
                              child: const TrackSettings(),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
