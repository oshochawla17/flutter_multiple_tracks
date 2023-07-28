import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/track_options_provider.dart';
import 'package:provider/provider.dart';

class TrackPlaylists extends StatefulWidget {
  const TrackPlaylists({super.key});

  @override
  State<TrackPlaylists> createState() => _TrackPlaylistsState();
}

class _TrackPlaylistsState extends State<TrackPlaylists> {
  bool isTrackOn = true;
  bool useGlobalPitch = true;
  bool useGlobalTempo = true;

  @override
  void initState() {
    final trackOptionsProvider = context.read<TrackOptionsProvider>();
    isTrackOn = trackOptionsProvider.options.isTrackOn;
    useGlobalPitch = trackOptionsProvider.options.useGlobalPitch;
    useGlobalTempo = trackOptionsProvider.options.useGlobalTempo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
          const Center(
            child: Text(
              'Track settings',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Track Status:'),
              Switch(
                  value: isTrackOn,
                  onChanged: (val) {
                    setState(() {
                      isTrackOn = val;
                    });
                  })
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Use global pitch:'),
                  Checkbox(
                      value: useGlobalPitch,
                      onChanged: (value) {
                        setState(() {
                          useGlobalPitch = value!;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  const Text('Use global tempo:'),
                  Checkbox(
                      value: useGlobalTempo,
                      onChanged: (value) {
                        setState(() {
                          useGlobalTempo = value!;
                        });
                      }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 30, right: 30),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TrackOptionsProvider>().updateOptions(
                            TrackOptions(
                              volume: 1,
                              isTrackOn: isTrackOn,
                              useGlobalPitch: useGlobalPitch,
                              useGlobalTempo: useGlobalTempo,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
