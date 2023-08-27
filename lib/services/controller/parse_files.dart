import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/metronome_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/swarmandal_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tabla_pakhawaj_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tanpura_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/metronome_library.dart.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/swarmandal_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tabla_pakhawaj_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tanpura_library.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

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
        if (sub.length < 2) {
          return null;
        }
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

  static TanpuraFile? parseTanpuraFiles(String file) {
    try {
      var splits = file.split('Tanpura/');
      if (splits.length > 1) {
        var sub = splits[1].split('/');
        if (sub.length < 2) {
          return null;
        }
        var subtype = sub[0];
        var fileName = sub[1];
        var tablaProps = fileName.split('-');
        if (tablaProps.length == 7) {
          // C#3-030-B2_-D#3-020-050-TT01.wav
          var scale = tablaProps[0].replaceAll('_', '');
          var tempo = tablaProps[1];
          var rangeStart = tablaProps[2].replaceAll('_', '');
          var rangeEnd = tablaProps[3];
          var tempoStart = tablaProps[4];
          var tempoEnd = tablaProps[5];

          return TanpuraFile(
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
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static InstrumentFile? parseSwarmandalFile(String file) {
    try {
      // C#3-030-B2_-D#3-020-050-TT01.wav

      var splits = file.split('Swarmandal/');
      if (splits.length > 1) {
        var sub = splits[1].split('/');
        if (sub.length < 2) {
          return null;
        }
        var subtype = sub[0];
        var fileName = sub[1];
        var tablaProps = fileName.split('-');
        if (tablaProps.length == 4) {
          // C#3-B2_-D#3-TT01.wav
          var scale = tablaProps[0].replaceAll('_', '');
          var rangeStart = tablaProps[1].replaceAll('_', '');
          var rangeEnd = tablaProps[2];

          return SwarmandalFile(
            name: fileName,
            path: file,
            originalScale: Scale.fromString(scale),
            subtype: subtype,
            scaleRange: [
              Scale.fromString(rangeStart),
              Scale.fromString(rangeEnd)
            ],
            isSelected: true,
          );
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static List<InstrumentFile>? parseTanpuraFiles(String file) {
  //   try {
  //     var splits = file.split('Tanpura/');
  //     if (splits.length > 1) {
  //       // 04-D3.wav
  //       var fileName = splits[1];
  //       var tanpuraProps = fileName.split('-');
  //       if (tanpuraProps.length == 2) {
  //         var scale = tanpuraProps[1].split('.')[0];
  //         return [
  //           TanpuraFile.tanpura1(
  //               name: fileName,
  //               path: file,
  //               originalScale: Scale.fromString(scale),
  //               isSelected: true),
  //           TanpuraFile.tanpura2(
  //               name: fileName,
  //               path: file,
  //               originalScale: Scale.fromString(scale),
  //               isSelected: true),
  //         ];
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  static Future<Map<Instruments, InstrumentLibrary>> traverseDirectory(
      String? rootPath) async {
    var systemTempDir = Directory.systemTemp;
    var uri = rootPath ?? systemTempDir;
    // var permission = await Permission.storage.request();
    // if (permission.isGranted) {
    //   print('Permission granted');
    // } else {
    //   print('Permission denied');
    // }

    // print(systemTempDir1.path);
    // final List<Directory>? appDocumentsDir =
    //     await getExternalStorageDirectories();
    // for (var dir in appDocumentsDir!) {
    //   print(dir.path);
    // }
    // await for (var entity
    //     in appDocumentsDir!.list(recursive: true, followLinks: false)) {
    //   if (entity is File) {
    //     print(entity.path);
    //   }
    // }

    // var uriDir = Directory.fromUri(uri);
    // await systemTempDir.createTemp('flutter_temp');

    await for (var entity
        in systemTempDir.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.contains('Audio.zip')) {
        final zipFile = File(entity.path);
        ZipFile.extractToDirectory(
            zipFile: zipFile, destinationDir: systemTempDir);
        // ZipFile.createFromDirectory(
        //     sourceDir: systemTempDir, zipFile: zipFile, recurseSubDirs: true);
      }
    }

    List<String> totalFiles = [];
    await for (var entity
        in systemTempDir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalFiles.add(entity.path);
      }
    }
    Map<String, List<TablaPakhawajFile>> tablaFiles = {};
    Map<String, List<TanpuraFile>> tanpuraFiles = {};
    Map<String, List<TablaPakhawajFile>> pakhawajFiles = {};
    Map<String, List<SwarmandalFile>> swarmandalFiles = {};
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
      } else if (file.contains('Tanpura')) {
        var parsedFile = parseTanpuraFiles(file);
        if (parsedFile == null) {
          continue;
        }

        var subtype = parsedFile.subtype;
        if (tanpuraFiles[subtype] == null) {
          tanpuraFiles[subtype] = [];
        }
        tanpuraFiles[subtype]!.add(parsedFile);
      } else if (file.contains('Swarmandal')) {
        var parsedFile = parseSwarmandalFile(file);
        if (parsedFile == null) {
          continue;
        }
        parsedFile = parsedFile as SwarmandalFile;
        var subtype = parsedFile.subtype;
        if (swarmandalFiles[subtype] == null) {
          swarmandalFiles[subtype] = [];
        }
        swarmandalFiles[subtype]!.add(parsedFile);
      }
    }

    TablaPakhawajLibrary tablaLibrary = TablaPakhawajLibrary.tabla(
      taalFiles: tablaFiles,
    );
    TablaPakhawajLibrary pakhawajLibrary = TablaPakhawajLibrary.pakhawaj(
      taalFiles: pakhawajFiles,
    );
    SwarmandalLibrary swarmandalLibrary =
        SwarmandalLibrary(raagFiles: swarmandalFiles);
    MetronomeLibrary metronomeLibrary =
        MetronomeLibrary(taalFiles: metronomeFiles);
    TanpuraLibrary tanpuraLibrary = TanpuraLibrary(subfiles: tanpuraFiles);

    return {
      Instruments.tabla: tablaLibrary,
      Instruments.pakhawaj: pakhawajLibrary,
      Instruments.metronome: metronomeLibrary,
      Instruments.tanpura1: tanpuraLibrary,
      Instruments.tanpura2: tanpuraLibrary,
      Instruments.swarmandal: swarmandalLibrary,
    };
  }
}
