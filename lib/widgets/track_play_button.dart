import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class TrackPlayButton extends StatelessWidget {
  const TrackPlayButton({
    Key? key,
    required this.onPlay,
    required this.onStop,
  }) : super(key: key);
  final Function onPlay;
  final Function onStop;
  @override
  Widget build(BuildContext context) {
    return Consumer<TrackPlaylistsStatus>(
      builder: (context, playlistProvider, child) {
        return ElevatedButton(
          onPressed: () {
            playlistProvider.isPlaying ? onStop() : onPlay();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
            backgroundColor: playlistProvider.isPlaying
                ? Colors.tealAccent
                : Colors.lightGreen, // <-- Button color
            foregroundColor: Colors.black, // <-- Splash color
          ),
          child: Center(
            child: Icon(
              playlistProvider.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        );
      },
    );
  }
}
