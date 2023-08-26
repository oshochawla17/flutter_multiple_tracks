import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/widgets/tanpura_sllider.dart';
import 'package:flutter_multiple_tracks/widgets/tempo_tuner.dart';
import 'package:flutter_multiple_tracks/widgets/tempo_tuner_local.dart';
import 'package:provider/provider.dart';

class TanpuraSettings extends StatelessWidget {
  const TanpuraSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TempoTunerLocal(
            onTempoChange: (int newVal) {
              if (newVal > 150) {
                newVal = 150;
              } else if (newVal < 60) {
                newVal = 60;
              }
              var provider = context.read<InstrumentTrack>();
              var globalProvider = context.read<GlobalOptionsProvider>();
              provider.updateFromLocal(provider.trackOptions.copyWith(
                tempo: newVal,
              ));
              provider.updateFromGlobal(globalProvider.options);
            },
          )),
    );
  }
}
