import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:provider/provider.dart';

class TrackPlayButton extends StatelessWidget {
  const TrackPlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalOptionsProvider>(
      builder: (context, optionsProvider, child) {
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: optionsProvider.options.isMasterPlaying
                ? Colors.red
                : Colors.lightGreen, // <-- Button color
            foregroundColor: Colors.black, // <-- Splash color
          ),
          child: Center(
            child: Icon(
              optionsProvider.options.isMasterPlaying
                  ? Icons.stop
                  : Icons.play_arrow,
            ),
          ),
        );
      },
    );
  }
}
