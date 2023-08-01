import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
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
    onStop(TrackPlaylistsStatus provider) async {
      await provider.stop();

      var globalTrackStatus =
          // ignore: use_build_context_synchronously
          context.read<GlobalTrackStatus>();
      for (TrackPlaylistsStatus status in globalTrackStatus.playlistsStatus) {
        if (status.isPlaying) {
          return;
        }
      }
      globalTrackStatus.updateIsPlaying(false);
    }

    return Consumer<TrackPlaylistsStatus>(builder: (context, provider, child) {
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
                    Row(
                      children: [
                        Switch(
                            value: provider.options.isTrackOn,
                            onChanged: (val) {
                              provider.updateOptions(
                                  provider.options.copyWith(isTrackOn: val));
                              if (!val) {
                                onStop(provider);
                              }
                            })
                      ],
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
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: "",
                              builder: (BuildContext builderContext) {
                                final trackOptionsProvider =
                                    context.read<TrackPlaylistsStatus>();
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<
                                        TrackPlaylistsStatus>.value(
                                      value: trackOptionsProvider,
                                      child: const TrackSettings(),
                                    ),
                                    ChangeNotifierProvider<
                                        GlobalOptionsProvider>.value(
                                      value:
                                          context.read<GlobalOptionsProvider>(),
                                    ),
                                  ],
                                  child:
                                      // create dialog with close   button
                                      // close on outside click

                                      AlertDialog(
                                    title: const Text('Track Settings'),
                                    content: const TrackSettings(),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
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
                          isScrollControlled: true,
                          builder: (BuildContext builderContext) {
                            final trackOptionsProvider =
                                context.read<TrackPlaylistsStatus>();
                            return SingleChildScrollView(
                              child: ChangeNotifierProvider<
                                  TrackPlaylistsStatus>.value(
                                value: trackOptionsProvider,
                                child: const TrackPlaylistsSheet(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const VolumeBar(),
                    TrackPlayButton(
                        isTrackOn: provider.options.isTrackOn,
                        onPlay: () {
                          if (!provider.options.isTrackOn) {
                            return;
                          }
                          var futures = provider.play();
                          if (futures.isNotEmpty) {
                            for (var element in futures) {
                              element();
                            }

                            context
                                .read<GlobalTrackStatus>()
                                .updateIsPlaying(true);
                          }
                        },
                        onStop: () => onStop(provider)),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
