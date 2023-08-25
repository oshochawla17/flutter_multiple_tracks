import 'package:flutter/material.dart';

import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tabla_track.dart';
import 'package:provider/provider.dart';

class TaalDropdown extends StatelessWidget {
  const TaalDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      var tablaProvider = provider as TablaPakhawajTrack;
      return DropdownButton<String>(
        value: tablaProvider.selectedTaal,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          var globalOptionsProvider = context.read<GlobalOptionsProvider>();
          var globalTrackStatus = context.read<GlobalTrackStatus>();
          tablaProvider.selectTaal(
              taal: value!, globalOptions: globalOptionsProvider.options);

          globalOptionsProvider.updateOptions(
            globalOptionsProvider.options.copyWith(selectedTaal: value),
          );
          globalTrackStatus.updateTaal(globalOptionsProvider.options);
        },
        items: (tablaProvider.library?.taalFiles ?? {})
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
