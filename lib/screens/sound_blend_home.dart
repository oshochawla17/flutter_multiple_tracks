import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_multiple_tracks/services/bloc/master_bloc/master.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/instruments_playing_status_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/library_provider.dart';
import 'package:flutter_multiple_tracks/widgets/audio_directory.dart';
import 'package:flutter_multiple_tracks/widgets/instuments_section/instruments_sections.dart';
import 'package:flutter_multiple_tracks/widgets/master_row.dart';
import 'package:flutter_multiple_tracks/widgets/scale_tuner.dart';
import 'package:flutter_multiple_tracks/widgets/tempo_tuner.dart';
import 'package:provider/provider.dart';

class SoundBlendHome extends StatelessWidget {
  const SoundBlendHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Saath Studio'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<GlobalOptionsProvider>(
            create: (context) => GlobalOptionsProvider(),
          ),
          ChangeNotifierProvider<GlobalTrackStatus>(
            create: (context) => GlobalTrackStatus(),
          ),
          // ChangeNotifierProvider<LibraryProvider>(
          //   create: (context) => LibraryProvider(),
          // ),
          // ChangeNotifierProvider<InstrumentsPlayingStatusProvider>(
          //   create: (context) => InstrumentsPlayingStatusProvider(),
          // ),
        ],
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              // const AudioDirectoryLoader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    const Expanded(child: ScaleTuner()),
                    Consumer2<GlobalOptionsProvider, GlobalTrackStatus>(
                        builder: (context, provider, trackStatus, child) {
                      return Expanded(
                        child: TempoTuner(
                          onTempoChange: (int newVal) {
                            if (newVal > TrackOptions.maxTempo) {
                              newVal = TrackOptions.maxTempo;
                            } else if (newVal < TrackOptions.minTempo) {
                              newVal = TrackOptions.minTempo;
                            }
                            var newOptions = provider.options.copyWith(
                              tempo: newVal,
                            );
                            provider.updateOptions(newOptions);
                            trackStatus.setTempo(newOptions);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const MasterRow(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(builder: (context) {
                  var instrumentsProvider = context.read<GlobalTrackStatus>();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(
                        instrumentsProvider.instruments.length ~/ 2,
                        (index) {
                          return Row(
                            children: [
                              Expanded(
                                child: ChangeNotifierProvider<
                                    InstrumentTrack>.value(
                                  value: instrumentsProvider
                                      .instruments[index * 2],
                                  child: InstrumentsSection(
                                      instrument: instrumentsProvider
                                          .instruments[index * 2].instrument),
                                ),
                              ),
                              Expanded(
                                child: ChangeNotifierProvider<
                                    InstrumentTrack>.value(
                                  value: instrumentsProvider
                                      .instruments[index * 2 + 1],
                                  child: InstrumentsSection(
                                      instrument: instrumentsProvider
                                          .instruments[index * 2 + 1]
                                          .instrument),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
