import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tabla_track.dart';
import 'package:flutter_multiple_tracks/utils/helper.dart';
import 'package:flutter_multiple_tracks/widgets/taal_dropdown.dart';
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
    onStop(InstrumentTrack provider) async {
      await provider.stop();

      var globalTrackStatus =
          // ignore: use_build_context_synchronously
          context.read<GlobalTrackStatus>();
      for (InstrumentTrack instrument in globalTrackStatus.instruments) {
        if (instrument.isPlaying) {
          return;
        }
      }
      globalTrackStatus.updateIsPlaying(false);
    }

    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      if (provider is TablaPakhawajTrack) {
        print('Track row rebuild ${provider.instrument.name}');

        print(
            'Current pitch semitones:  ${AudioHelper.pitchFactorToSemitones(provider.playlists.first.player.state.pitch)}');
        print('Current tempo:  ${provider.playlists.first.player.state.rate}');
        print(
            'Current media length:  ${provider.playlists.first.player.state.playlist.medias.length}');
      }
      return Builder(builder: (context) {
        return Card(
          elevation: 2,
          color:
              provider.trackOptions.isTrackOn ? Colors.white : Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                // create a dropdown
                if (provider is TablaPakhawajTrack)
                  Row(
                    children: [
                      const TaalDropdown(),
                      Opacity(
                        opacity: provider.isShuffle ? 1 : 0.5,
                        child: InkWell(
                            onTap: () {
                              provider.taggleShuffle();
                            },
                            child: const Icon(
                              Icons.shuffle,
                              size: 35,
                            )),
                      )
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                            value: provider.trackOptions.isTrackOn,
                            onChanged: (val) {
                              provider.updateFromLocal(provider.trackOptions
                                  .copyWith(isTrackOn: val));
                              if (!val) {
                                onStop(provider);
                              }
                            })
                      ],
                    ),
                    Text(
                      provider.instrument.name,
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
                                    context.read<InstrumentTrack>();
                                return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<
                                        InstrumentTrack>.value(
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
                                context.read<InstrumentTrack>();
                            return SingleChildScrollView(
                              child:
                                  ChangeNotifierProvider<InstrumentTrack>.value(
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
                        isTrackOn: provider.trackOptions.isTrackOn,
                        onPlay: () {
                          if (!provider.trackOptions.isTrackOn) {
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
                Text(
                    'Currently playing: ${provider.currentPlaying?.name ?? ''}'),
              ],
            ),
          ),
        );
      });
    });
  }
}
