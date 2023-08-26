import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/widgets/audio_directory.dart';
import 'package:flutter_multiple_tracks/widgets/clickable_text.dart';
import 'package:flutter_multiple_tracks/widgets/master_play_button.dart';
import 'package:flutter_multiple_tracks/widgets/scale_selector.dart';
import 'package:provider/provider.dart';

class MasterRow extends StatelessWidget {
  const MasterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 23,
          width: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {},
            child: const Icon(Icons.tune),
          ),
        ),
        const MasterPlayButton(),
        AudioDirectoryLoader(),
      ],
    );
  }
}
