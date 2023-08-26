import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/widgets/volume_bar.dart';
import 'package:provider/provider.dart';

class VolumeMixer extends StatelessWidget {
  const VolumeMixer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalTrackStatus>(builder: (context, provider, child) {
      return SizedBox(
        height: 300,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 40),
              child: Text('Volume Mixer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List<Widget>.generate(
                provider.instruments.length,
                (index) => ChangeNotifierProvider<InstrumentTrack>.value(
                  value: provider.instruments[index],
                  child: const VolumeBar(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
