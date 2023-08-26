import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/swarmandal_track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:provider/provider.dart';

class SwarmandalSettings extends StatefulWidget {
  const SwarmandalSettings({
    super.key,
  });
  @override
  State<SwarmandalSettings> createState() => _SwarmandalSettingsState();
}

class _SwarmandalSettingsState extends State<SwarmandalSettings> {
  late SwarmandalTrackOptions trackOptions;
  @override
  void initState() {
    final trackOptionsProvider = context.read<InstrumentTrack>();
    trackOptions = (trackOptionsProvider.trackOptions as SwarmandalTrackOptions)
        .deepCopy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onPitchChange(pitch) {}

    return SingleChildScrollView(
      child: Container(
        height: 280,
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
            Row(
              children: [
                const Text('Use global pitch:'),
                Checkbox(
                    value: trackOptions.useGlobalPitch,
                    onChanged: (value) {
                      setState(() {
                        trackOptions = trackOptions.copyWith(
                          useGlobalPitch: value!,
                        );
                      });
                      onPitchChange(trackOptions.pitch);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
