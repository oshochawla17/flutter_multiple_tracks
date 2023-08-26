import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/swarmandal_track.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/instruments_sections.dart';
import 'package:flutter_multiple_tracks/widgets/raag_dropdown.dart';
import 'package:flutter_multiple_tracks/widgets/swarmandal_settings.dart';
import 'package:flutter_multiple_tracks/widgets/track_play_button.dart';
import 'package:provider/provider.dart';

class SwarmandalSection extends InstrumentsSection {
  const SwarmandalSection({
    super.key,
  }) : super(instrument: Instruments.swarmandal);

  @override
  Widget build(BuildContext context) {
    return Consumer<InstrumentTrack>(builder: (context, instrument, child) {
      return Card(
        elevation: 2,
        child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const TrackPlayButton(),
                const SizedBox(
                  height: 5,
                ),
                const RaagDropdown(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: "",
                            builder: (BuildContext builderContext) {
                              final trackOptionsProvider =
                                  context.read<InstrumentTrack>();
                              return MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<InstrumentTrack>.value(
                                    value: trackOptionsProvider,
                                  ),
                                  ChangeNotifierProvider<
                                      GlobalOptionsProvider>.value(
                                    value:
                                        context.read<GlobalOptionsProvider>(),
                                  ),
                                ],
                                child: AlertDialog(
                                  title: Text(
                                      '${instrument.instrument.name} Settings'),
                                  content: const SwarmandalSettings(),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.settings),
                      ),
                    ),
                    Opacity(
                      opacity:
                          (instrument as SwarmandalTrack).isShuffle ? 1 : 0.5,
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(2),
                        child: InkWell(
                          onTap: () {
                            instrument.toggleShuffle();
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
  }
}
