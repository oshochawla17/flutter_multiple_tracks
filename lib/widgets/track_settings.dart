import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class TrackSettings extends StatefulWidget {
  const TrackSettings({
    super.key,
  });
  @override
  State<TrackSettings> createState() => _TrackSettingsState();
}

class _TrackSettingsState extends State<TrackSettings> {
  bool isTrackOn = true;
  bool useGlobalPitch = true;
  bool useGlobalTempo = true;

  @override
  void initState() {
    final trackOptionsProvider = context.read<TrackPlaylistsStatus>();
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
                      final providerVal = context.read<TrackPlaylistsStatus>();
                      providerVal.updateOptions(
                        TrackOptions(
                          volume: providerVal.options.volume,
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
