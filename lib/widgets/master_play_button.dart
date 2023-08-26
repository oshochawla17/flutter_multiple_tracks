import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/instruments_playing_status_provider.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_multiple_tracks/services/bloc/master_bloc/master.dart';

class MasterPlayButton extends StatelessWidget {
  const MasterPlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalTrackStatus, InstrumentsPlayingStatusProvider>(
        builder: (context, provider, playStatus, child) {
      bool isPlaying = playStatus.isPlaying();
      print('.....');
      return ElevatedButton(
        onPressed: () {
          isPlaying ? provider.stop() : provider.play();
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor:
              isPlaying ? Colors.red : Colors.lightGreen, // <-- Button color
          foregroundColor: Colors.black, // <-- Splash color
        ),
        child: Icon(
          isPlaying ? Icons.stop : Icons.play_arrow,
        ),
      );
    });
  }
}
