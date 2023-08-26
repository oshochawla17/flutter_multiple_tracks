import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/instruments_playing_status_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:provider/provider.dart';

class TrackPlayButton extends StatelessWidget {
  const TrackPlayButton({
    Key? key,
    required this.onPlay,
    required this.onStop,
    required this.isTrackOn,
  }) : super(key: key);
  final Function onPlay;
  final Function onStop;
  final bool isTrackOn;
  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(
      builder: (context, provider, child) {
        print('selector isPlaying: $provider ');
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<InstrumentsPlayingStatusProvider>(context, listen: false)
              .updateInstrumentStatus(provider.instrument, provider.isPlaying);
        });

        return ElevatedButton(
          onPressed: !isTrackOn
              ? null
              : () {
                  provider.isPlaying ? onStop() : onPlay();
                },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
            backgroundColor: provider.isPlaying
                ? Colors.red
                : Colors.lightGreen, // <-- Button color
            foregroundColor: Colors.black, // <-- Splash color
          ),
          child: Center(
            child: Icon(
              provider.isPlaying ? Icons.stop : Icons.play_arrow,
            ),
          ),
        );
      },
    );
  }
}
