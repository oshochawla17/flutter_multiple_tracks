import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_multiple_tracks/services/bloc/master_bloc/master.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/widgets/master_row.dart';
import 'package:flutter_multiple_tracks/widgets/track_row.dart';
import 'package:provider/provider.dart';

class SoundBlendHome extends StatelessWidget {
  const SoundBlendHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Sound Blend'),
        title: Container(),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<GlobalOptionsProvider>(
            create: (context) => GlobalOptionsProvider(),
          ),
          // BlocProvider<MasterBloc>(
          //   create: (context) => MasterBloc(),
          // ),
        ],
        child: Column(
          children: [
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
                child: ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TrackRow(index: index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
