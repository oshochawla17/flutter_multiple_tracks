import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/controller/parse_files.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tabla_pakhawaj_library.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/library_provider.dart';
import 'package:provider/provider.dart';

class AudioDirectoryLoader extends StatefulWidget {
  const AudioDirectoryLoader({
    super.key,
  });

  @override
  State<AudioDirectoryLoader> createState() => _AudioDirectoryLoaderState();
}

class _AudioDirectoryLoaderState extends State<AudioDirectoryLoader> {
  String? directorySelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FileParser.currentRootDirectory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          updateLibrary() => FileParser.traverseDirectory(directorySelected!)
                  .then((libraries) {
                var libraryProvider = context.read<LibraryProvider>();

                libraryProvider.updateLibrary(libraries);
                TablaPakhawajLibrary tablaLib =
                    (libraries[Instruments.tabla]! as TablaPakhawajLibrary);
                String? selectedTaal;
                if (tablaLib.taalFiles.isNotEmpty) {
                  selectedTaal = tablaLib.taalFiles.keys.first;
                }
                var globalOptionsProvider =
                    context.read<GlobalOptionsProvider>();
                var globalOptions = globalOptionsProvider.options
                    .copyWith(selectedTaal: selectedTaal);
                var globalTrackStatus = context.read<GlobalTrackStatus>();
                globalTrackStatus.load(libraries);
                globalTrackStatus.updateFromGlobal(globalOptions);
                globalOptionsProvider.updateOptions(globalOptions);
              });
          onSelected() => FileParser.selectRootDirectory().then((value) {
                if (value != null) {
                  setState(() {
                    directorySelected = value;
                  });
                  updateLibrary();
                }
              });
          if (snapshot.hasData) {
            directorySelected = snapshot.data.toString();
            updateLibrary();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Currrent directory selected:'),
                    Text(directorySelected!,
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
                ElevatedButton(
                  onPressed: onSelected,
                  child: const Text('Select another directory'),
                ),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: onSelected,
              child: const Text('Select root directory'),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
