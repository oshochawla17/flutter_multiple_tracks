import 'package:flutter/material.dart';

import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tanpura_track.dart';
import 'package:provider/provider.dart';

class TanpuraDropdown extends StatelessWidget {
  const TanpuraDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      var tanpura = provider as TanpuraTrack;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(5),
        child: DropdownButton<String>(
          value: tanpura.selectedSub,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? value) {
            var globalOptionsProvider = context.read<GlobalOptionsProvider>();
            var globalTrackStatus = context.read<GlobalTrackStatus>();
            tanpura.selectTaal(
                taal: value!, globalOptions: globalOptionsProvider.options);

            globalOptionsProvider.updateOptions(
              globalOptionsProvider.options.copyWith(selectedTaal: value),
            );
            globalTrackStatus.updateTaal(globalOptionsProvider.options);
          },
          items: (tanpura.library?.subfiles ?? {})
              .keys
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value, textAlign: TextAlign.center)),
            );
          }).toList(),
        ),
      );
    });
  }
}
