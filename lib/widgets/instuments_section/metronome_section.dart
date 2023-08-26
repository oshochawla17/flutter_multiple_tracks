import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/instruments_sections.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';

class MetronomeSection extends InstrumentsSection {
  const MetronomeSection({
    super.key,
  }) : super(instrument: Instruments.metronome);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5),
          child: const Column(
            children: [
              TrackPlayButton(),
            ],
          )),
    );
  }
}
