import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_multiple_tracks/services/bloc/master_bloc/master.dart';

class MasterPlayButton extends StatelessWidget {
  const MasterPlayButton({Key? key}) : super(key: key);
  final bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // context.read<MasterBloc>().add(MasterPlayEvent());
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
  }
}
