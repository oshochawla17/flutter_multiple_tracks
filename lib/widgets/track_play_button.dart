import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/instruments_playing_status_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:provider/provider.dart';

class TrackPlayButton extends StatelessWidget {
  const TrackPlayButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<InstrumentsPlayingStatusProvider>(context, listen: false)
              .updateInstrumentStatus(provider.instrument, provider.isPlaying);
        });

        return Container(
          child: ElevatedButton(
              onPressed: !provider.isPlaying && !provider.trackOptions.isTrackOn
                  ? () async {
                      var result = await provider.play();
                      if (result) {
                        // ignore: use_build_context_synchronously
                        context.read<GlobalTrackStatus>().updateIsPlaying(true);
                      }
                    }
                  : () async {
                      await provider.stop();
                      provider.updateFromLocal(provider.trackOptions.copyWith(
                        isTrackOn: false,
                      ));
                      var globalTrackStatus =
                          // ignore: use_build_context_synchronously
                          context.read<GlobalTrackStatus>();
                      for (InstrumentTrack instrument
                          in globalTrackStatus.instruments) {
                        if (instrument.isPlaying) {
                          return;
                        }
                      }
                      globalTrackStatus.updateIsPlaying(false);
                    },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: provider.trackOptions.isTrackOn
                    ? Colors.lightBlue
                    : Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    provider.instrument.imagePath(),
                    height: 30,
                    width: 30,
                  ),
                  Text(
                    provider.instrument.instrumentName(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
