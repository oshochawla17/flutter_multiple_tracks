import 'package:flutter/material.dart';

import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/swarmandal_track.dart';
import 'package:provider/provider.dart';

class RaagDropdown extends StatelessWidget {
  const RaagDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      var swarmandal = provider as SwarmandalTrack;
      return DropdownButton<String>(
        value: swarmandal.selectedRaag,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (String? value) {
          var globalOptionsProvider = context.read<GlobalOptionsProvider>();

          swarmandal.selectRaag(
              raag: value!, globalOptions: globalOptionsProvider.options);
        },
        items: (swarmandal.library?.raagFiles ?? {})
            .keys
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
