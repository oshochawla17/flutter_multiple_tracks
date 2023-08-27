import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_multiple_tracks/services/controller/parse_files.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tabla_pakhawaj_library.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/services/providers/global_track_status.dart';
import 'package:flutter_multiple_tracks/services/providers/library_provider.dart';
import 'package:provider/provider.dart';

class AudioDirectoryDownloader extends StatefulWidget {
  const AudioDirectoryDownloader({
    super.key,
  });

  @override
  State<AudioDirectoryDownloader> createState() =>
      _AudioDirectoryDownloaderState();
}

class _AudioDirectoryDownloaderState extends State<AudioDirectoryDownloader> {
  String? directorySelected;
  bool isDownloading = false;
  int progress = 0;
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    print('Download callback $id $status $progress');

    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send == null) {
      print('Download callback send is null');
      return;
    }
    send.send([id, status, progress]);
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      // DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      var newProgress = data[2];
      if (progress != newProgress && progress == 100) {
        updateLibrary();
      }
      progress = data[2];

      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  Future updateLibrary() =>
      FileParser.traverseDirectory(directorySelected).then((libraries) {
        // var libraryProvider = context.read<LibraryProvider>();

        // libraryProvider.updateLibrary(libraries);
        TablaPakhawajLibrary tablaLib =
            (libraries[Instruments.tabla]! as TablaPakhawajLibrary);
        String? selectedTaal;
        if (tablaLib.taalFiles.isNotEmpty) {
          selectedTaal = tablaLib.taalFiles.keys.first;
        }
        var globalOptionsProvider = context.read<GlobalOptionsProvider>();
        var globalOptions =
            globalOptionsProvider.options.copyWith(selectedTaal: selectedTaal);
        var globalTrackStatus = context.read<GlobalTrackStatus>();
        globalTrackStatus.load(libraries);
        globalTrackStatus.updateFromGlobal(globalOptions);
        globalOptionsProvider.updateOptions(globalOptions);
      });
  @override
  Widget build(BuildContext context) {
    onDownload() async {
      var systemDir = Directory.systemTemp;
      var link = 'https://www.gr8masters.com/FlutterAudio/Audio.zip';
      final taskId = await FlutterDownloader.enqueue(
        url: link,
        headers: {},
        savedDir: systemDir.path,
        showNotification: true,
        openFileFromNotification: false,
      );
      await FlutterDownloader.registerCallback(downloadCallback);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onDownload,
          child: const Icon(Icons.download),
        ),
        if (progress > 0) Text('$progress %'),
      ],
    );
  }
}
