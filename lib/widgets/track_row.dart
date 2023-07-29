import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';
import 'package:flutter_multiple_tracks/widgets/track_playlists_sheet.dart';
import 'package:flutter_multiple_tracks/widgets/track_settings.dart';
import 'package:flutter_multiple_tracks/widgets/volume_bar.dart';
import 'package:provider/provider.dart';

class TrackRow extends StatelessWidget {
  const TrackRow({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TrackPlaylistsStatus>(
          create: (context) => TrackPlaylistsStatus(),
        ),
      ],
      child: Consumer2<TrackPlaylistsStatus, GlobalOptionsProvider>(
          builder: (context, provider, globalOptionsProvider, child) {
        // if (provider.options.isTrackOn) {
        //   if (globalOptionsProvider.options.isMasterPlaying) {
        //     provider.play();
        //   } else {
        //     provider.pause();
        //   }
        // }

        return Builder(builder: (context) {
          return Card(
            elevation: 2,
            color: provider.options.isTrackOn ? Colors.white : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                        child: InkWell(
                          child: const Icon(
                            Icons.remove_circle,
                            size: 30,
                          ),
                          onTap: () {},
                        ),
                      ),
                      Text(
                        'Track ${index + 1}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: InkWell(
                            child: const Icon(
                              Icons.settings_outlined,
                              size: 25,
                            ),
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext builderContext) {
                                  final trackOptionsProvider =
                                      context.read<TrackPlaylistsStatus>();
                                  return ChangeNotifierProvider<
                                      TrackPlaylistsStatus>.value(
                                    value: trackOptionsProvider,
                                    child: const TrackSettings(),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.playlist_play,
                          size: 35,
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext builderContext) {
                              final trackOptionsProvider =
                                  context.read<TrackPlaylistsStatus>();
                              return ChangeNotifierProvider<
                                  TrackPlaylistsStatus>.value(
                                value: trackOptionsProvider,
                                child: const TrackPlaylistsSheet(),
                              );
                            },
                          );
                        },
                      ),
                      const VolumeBar(),
                      TrackPlayButton(onPlay: () {
                        provider.play();
                      }, onStop: () {
                        provider.pause();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
