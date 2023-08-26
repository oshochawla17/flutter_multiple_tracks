import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/instruments_sections.dart';
import 'package:flutter_multiple_tracks/widgets/tanupura_scale_dropdown.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';
import 'package:provider/provider.dart';

class TanpuraSection extends InstrumentsSection {
  const TanpuraSection({super.key, required Instruments instrument})
      : super(instrument: instrument);

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, instrument, child) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.all(0),
        child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: const Column(
              children: [
                TrackPlayButton(),
                SizedBox(
                  height: 5,
                ),
                TanpuraScaleDropdown(),
              ],
            )),
      );
    });
  }
}
