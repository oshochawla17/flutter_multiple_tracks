import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/metronome_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tabla_pakhawaj_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/metronome_library.dart.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tabla_pakhawaj_library.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileParser {
  static Future<String?> currentRootDirectory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rootDir = prefs.getString('rootDir');
    return rootDir;
  }

  static Future<String?> selectRootDirectory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? result = await FilePicker.platform.getDirectoryPath();
    String rootPath = '';

    if (result != null) {
      rootPath = result;
      await prefs.setString('rootDir', rootPath);
      return rootPath;
    } else {
      return null;
    }
  }

  static InstrumentFile? parseTablaPakhaawajFile(String file) {
    try {
      bool isTabla = file.contains('Tabla');
      var splits = isTabla ? file.split('Tabla/') : file.split('Pakhawaj/');
      if (splits.length > 1) {
        var sub = splits[1].split('/');
        var subtype = sub[0];
        var fileName = sub[1];
        var tablaProps = fileName.split('-');
        if (tablaProps.length == 4 && isTabla) {
          // metronome file
          // 080-000-120-TTM01.wav
          return MetronomeFile(
              name: fileName,
              path: file,
              subtype: subtype,
              originalTempo: int.parse(tablaProps[0]),
              tempoRange: [int.parse(tablaProps[1]), int.parse(tablaProps[2])],
              isSelected: true);
        } else if (tablaProps.length == 7) {
          // C#3-030-B2_-D#3-020-050-TT01.wav
          var scale = tablaProps[0].replaceAll('_', '');
          var tempo = tablaProps[1];
          var rangeStart = tablaProps[2].replaceAll('_', '');
          var rangeEnd = tablaProps[3];
          var tempoStart = tablaProps[4];
          var tempoEnd = tablaProps[5];

          if (isTabla) {
            return TablaPakhawajFile.tabla(
                name: fileName,
                path: file,
                originalScale: Scale.fromString(scale),
                subtype: subtype,
                originalTempo: int.parse(tempo),
                tempoRange: [int.parse(tempoStart), int.parse(tempoEnd)],
                scaleRange: [
                  Scale.fromString(rangeStart),
                  Scale.fromString(rangeEnd)
                ],
                isSelected: true);
          } else {
            return TablaPakhawajFile.pakhawaj(
              name: fileName,
              path: file,
              originalScale: Scale.fromString(scale),
              subtype: subtype,
              originalTempo: int.parse(tempo),
              tempoRange: [int.parse(tempoStart), int.parse(tempoEnd)],
              scaleRange: [
                Scale.fromString(rangeStart),
                Scale.fromString(rangeEnd)
              ],
              isSelected: true,
            );
          }
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<Instruments, InstrumentLibrary>> traverseDirectory(
      String rootPath) async {
    var uri = Uri.parse(rootPath);
    var systemTempDir = Directory.fromUri(uri);

    List<String> totalFiles = [];
    await for (var entity
        in systemTempDir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalFiles.add(entity.path);
      }
    }
    Map<String, List<TablaPakhawajFile>> tablaFiles = {};
    Map<String, List<TablaPakhawajFile>> pakhawajFiles = {};
    Map<String, List<MetronomeFile>> metronomeFiles = {};

    for (String file in totalFiles) {
      if (file.contains('Tabla') || file.contains('Pakhawaj')) {
        bool isTabla = file.contains('Tabla');
        var parsedFile = parseTablaPakhaawajFile(file);
        if (parsedFile == null) {
          continue;
        }
        if (isTabla) {
          if (parsedFile is MetronomeFile) {
            var subtype = parsedFile.subtype;
            if (metronomeFiles[subtype] == null) {
              metronomeFiles[subtype] = [];
            }
            metronomeFiles[subtype]!.add(parsedFile);
          } else if (parsedFile is TablaPakhawajFile) {
            var subtype = parsedFile.subtype;
            if (tablaFiles[subtype] == null) {
              tablaFiles[subtype] = [];
            }
            tablaFiles[subtype]!.add(parsedFile);
          }
        } else {
          var subtype = (parsedFile as TablaPakhawajFile).subtype;
          if (pakhawajFiles[subtype] == null) {
            pakhawajFiles[subtype] = [];
          }
          pakhawajFiles[subtype]!.add(parsedFile);
        }
      }
    }

    TablaPakhawajLibrary tablaLibrary = TablaPakhawajLibrary.tabla(
      taalFiles: tablaFiles,
    );
    TablaPakhawajLibrary pakhawajLibrary = TablaPakhawajLibrary.pakhawaj(
      taalFiles: pakhawajFiles,
    );
    MetronomeLibrary metronomeLibrary =
        MetronomeLibrary(taalFiles: metronomeFiles);
    return {
      Instruments.tabla: tablaLibrary,
      Instruments.pakhawaj: pakhawajLibrary,
      Instruments.metronome: metronomeLibrary,
    };
  }
}
