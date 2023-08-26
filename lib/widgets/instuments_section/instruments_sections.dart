import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/metronome_section.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/swarmandal_section.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/tabla_pakhawaj_section.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/tanpura_section.dart';
import 'package:provider/provider.dart';

class InstrumentsSection extends StatelessWidget {
  const InstrumentsSection({
    required this.instrument,
    super.key,
  });
  final Instruments instrument;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(3),
        child: Stack(
          children: [
            Builder(builder: (context) {
              switch (instrument) {
                case Instruments.metronome:
                  return const MetronomeSection();
                case Instruments.tanpura1:
                  return const TanpuraSection(
                    instrument: Instruments.tanpura1,
                  );
                case Instruments.tanpura2:
                  return const TanpuraSection(instrument: Instruments.tanpura2);
                case Instruments.tabla:
                  return const TablaPakhawajSection(
                    instrument: Instruments.tabla,
                  );
                case Instruments.pakhawaj:
                  return const TablaPakhawajSection(
                    instrument: Instruments.pakhawaj,
                  );
                case Instruments.swarmandal:
                  return const SwarmandalSection();
              }
            }),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const MuteWidget(),
              ),
            ),
          ],
        ));
  }
}

class MuteWidget extends StatelessWidget {
  const MuteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, provider, child) {
      return InkWell(
        child: Icon(
            provider.trackOptions.isMute ? Icons.volume_off : Icons.volume_down,
            color: provider.trackOptions.isMute
                ? Colors.grey.withOpacity(0.5)
                : Colors.grey),
        onTap: () {
          provider.trackOptions.isMute
              ? context.read<InstrumentTrack>().unmute()
              : context.read<InstrumentTrack>().mute();
        },
      );
    });
  }
}
