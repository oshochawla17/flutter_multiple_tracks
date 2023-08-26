import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/swarmandal_track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
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
  // bool isTrackOn = true;
  // bool useGlobalPitch = true;
  // late int? pitch;

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
    onPitchChange(pitch) {
      final providerVal = context.read<InstrumentTrack>();

      var newUseGlobalPitch = trackOptions.useGlobalPitch;
      if (newUseGlobalPitch) {
        // set pitch to global pitch value
        var globalOptionsProvider = context.read<GlobalOptionsProvider>();
        providerVal.setPitch(globalOptionsProvider.options.pitch);
      } else {
        // set pitch to default
        providerVal.setPitch(pitch);
      }
      providerVal.updateFromLocal(
        trackOptions.copyWith(
          volume: providerVal.trackOptions.volume,
          isMute: providerVal.trackOptions.isMute,
          isTrackOn: trackOptions.isTrackOn,
          useGlobalPitch: trackOptions.useGlobalPitch,
          useGlobalTempo: trackOptions.useGlobalTempo,
          pitch: pitch,
          tempo: trackOptions.tempo,
        ),
      );
    }

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
