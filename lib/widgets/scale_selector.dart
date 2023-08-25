import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:provider/provider.dart';

class ScaleSelector extends StatelessWidget {
  const ScaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalOptionsProvider>(builder: (context, provider, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                MusicNote newNote = MusicNote.values[
                    (provider.options.note.index - 1) %
                        MusicNote.values.length];
                var newOptions = provider.options.copyWith(
                  note: newNote,
                );
                provider.updateOptions(newOptions);
                context.read<GlobalTrackStatus>().updateScale(newOptions);
              },
              child: const Center(child: Icon(Icons.remove))),
          const SizedBox(width: 10),
          Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                provider.options.note.name(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                var newNote = MusicNote.values[
                    (provider.options.note.index + 1) %
                        MusicNote.values.length];
                var newOptions = provider.options.copyWith(
                  note: newNote,
                );
                provider.updateOptions(newOptions);
                context.read<GlobalTrackStatus>().updateScale(newOptions);
              },
              child: const Center(child: Icon(Icons.add))),
        ],
      );
    });
  }
}
