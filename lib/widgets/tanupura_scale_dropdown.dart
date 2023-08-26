import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';

import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tanpura_track.dart';
import 'package:provider/provider.dart';

class TanpuraScaleDropdown extends StatelessWidget {
  const TanpuraScaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      var tanpura = provider as TanpuraTrack;
      return DropdownButton<Scale>(
        value: tanpura.chosenScale,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (Scale? value) {
          tanpura.updatePlaylist1Scale(
              value, context.read<GlobalOptionsProvider>().options);
        },
        items: tanpura.availableNotes().map<DropdownMenuItem<Scale>>((value) {
          return DropdownMenuItem<Scale>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    });
  }
}
