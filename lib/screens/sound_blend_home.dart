import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_multiple_tracks/services/bloc/master_bloc/master.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/instruments_playing_status_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/library_provider.dart';
import 'package:flutter_multiple_tracks/widgets/audio_directory.dart';
import 'package:flutter_multiple_tracks/widgets/master_row.dart';
import 'package:flutter_multiple_tracks/widgets/track_row.dart';
import 'package:provider/provider.dart';

class SoundBlendHome extends StatelessWidget {
  const SoundBlendHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: const Text('Sound Blend'),
        title: Container(),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<GlobalOptionsProvider>(
            create: (context) => GlobalOptionsProvider(),
          ),
          ChangeNotifierProvider<GlobalTrackStatus>(
            create: (context) => GlobalTrackStatus(),
          ),
          ChangeNotifierProvider<LibraryProvider>(
            create: (context) => LibraryProvider(),
          ),
          ChangeNotifierProvider<InstrumentsPlayingStatusProvider>(
            create: (context) => InstrumentsPlayingStatusProvider(),
          ),
        ],
        child: Column(
          children: [
            const AudioDirectoryLoader(),
            const Text(
              'Sound Blend',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: MasterRow(),
            ),
            const Padding(
              padding: EdgeInsets.all(0),
              child: Divider(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(builder: (context) {
                  var instrumentsProvider = context.read<GlobalTrackStatus>();
                  return ListView.builder(
                    itemCount: instrumentsProvider.instruments.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: instrumentsProvider.instruments[index],
                          child: TrackRow(index: index));
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
