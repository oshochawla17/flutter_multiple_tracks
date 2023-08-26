import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tabla_track.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/instruments_sections.dart';
import 'package:flutter_multiple_tracks/widgets/taal_dropdown.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';
import 'package:flutter_multiple_tracks/widgets/track_playlists_sheet.dart';
import 'package:provider/provider.dart';

class TablaPakhawajSection extends InstrumentsSection {
  const TablaPakhawajSection({
    required Instruments instrument,
    super.key,
  }) : super(instrument: instrument);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Consumer<InstrumentTrack>(builder: (context, instrument, child) {
        print('TablaPakhawajSection build');
        return Card(
          elevation: 2,
          child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  const TrackPlayButton(),
                  const SizedBox(
                    height: 2,
                  ),
                  const SizedBox(height: 50, child: TaalDropdown()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(2),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext builderContext) {
                                final trackOptionsProvider =
                                    context.read<InstrumentTrack>();
                                return SingleChildScrollView(
                                  child: ChangeNotifierProvider<
                                      InstrumentTrack>.value(
                                    value: trackOptionsProvider,
                                    child: const TrackPlaylistsSheet(),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.settings),
                        ),
                      ),
                      Opacity(
                        opacity: (instrument as TablaPakhawajTrack).isShuffle
                            ? 1
                            : 0.5,
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: const EdgeInsets.all(2),
                          child: InkWell(
                            onTap: () {
                              (instrument).toggleShuffle();
                            },
                            child: const Icon(Icons.shuffle),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 50,
                      //   width: 50,
                      //   padding: const EdgeInsets.all(2),
                      //   child: InkWell(
                      //     onTap: () {},
                      //     child: const Icon(Icons.shuffle),
                      //   ),
                      // ),
                    ],
                  )
                ],
              )),
        );
      });
    });
  }
}
