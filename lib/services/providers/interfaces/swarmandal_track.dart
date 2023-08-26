import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/swarmandal_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/swarmandal_library.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/swarmandal_track_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:flutter_multiple_tracks/utils/helper.dart';
import 'package:media_kit/media_kit.dart';

class SwarmandalTrack with ChangeNotifier implements InstrumentTrack {
  SwarmandalTrack({
    this.trackOptions = const SwarmandalTrackOptions(),
  });

  final TrackPlaylist _playlist = TrackPlaylist(useLoop: false);

  SwarmandalLibrary? library;

  String? selectedRaag;

  bool isShuffle = false;

  @override
  SwarmandalFile? currentPlaying;

  @override
  bool isPlaying = false;

  @override
  final Instruments instrument = Instruments.swarmandal;

  @override
  TrackOptions trackOptions;

  @override
  Future<bool> mute() async {
    trackOptions = trackOptions.copyWith(isMute: true);
    await _playlist.player.setVolume(0);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> play() async {
    // List<Future<void> Function()> futures = [];
    // updateFromGlobal(null).then((value) {
    //   _playlist.player.play();
    // });
    // for (var playlist in playlists) {
    //   if (playlist.selectedFiles.isEmpty) continue;
    //   futures.add(playlist.player.play);
    // }
    // return futures;
    var resullt = await updateFromGlobal(null);
    if (!resullt) {
      isPlaying = false;
      notifyListeners();
      return false;
    }
    await _playlist.player.play();
    return resullt;
  }

  Timer? timer;
  bool stopPlaying = false;

  @override
  Future<bool> stop() async {
    await _playlist.resetPlaylist();
    return true;
  }

  int index = 0;
  @override
  void load(InstrumentLibrary library) {
    this.library = library as SwarmandalLibrary;
    if (library.raagFiles.isNotEmpty) {
      selectedRaag = library.raagFiles.keys.first;
    }
    _playlist.player.stream.playlist.listen((event) {
      index = event.index;
    });
    _playlist.player.stream.completed.listen((event) async {
      if (event) {
        timer?.cancel();
        await _playlist.player.pause();
        timer = Timer(Duration(milliseconds: 1500), () async {
          _playlist.files.removeAt(0);
          if (_playlist.files.isEmpty) {
            isPlaying = false;
            _playlist.player.stop();
          } else {
            await _playlist.player.open(
              Playlist(_playlist.selectedMediaFiles()),
              play: _playlist.player.state.playing,
            );
          }
        });
      }
    });
    _playlist.player.stream.playing.listen((event) {
      isPlaying = event;
      notifyListeners();
    });
    _playlist.player.stream.playlist.listen((event) {
      if (event.medias.isNotEmpty) {
        currentPlaying = _playlist.files.firstWhere(
                (element) => element.path == event.medias[event.index].uri)
            as SwarmandalFile;

        notifyListeners();
      }
    });
  }

  @override
  bool updateFromLocal(TrackOptions localOptions) {
    trackOptions = localOptions;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> setPitch(
      int cents, SoundBlendGlobalOptions globalOptions) async {
    // return updateFromGlobalWithScale(globalOptions, chosenScale);
    var pitchFactor =
        AudioHelper.semitonesToPitchFactor((globalOptions.pitch / 100));
    for (var element in playlists) {
      await element.player.setPitch(pitchFactor);
    }
    return true;
  }

  @override
  List<TrackPlaylist> get playlists => [_playlist];

  @override
  Future<bool> unmute() async {
    trackOptions = trackOptions.copyWith(isMute: false);
    await _playlist.player.setVolume(trackOptions.volume * 100);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> setVolume(double volume) async {
    trackOptions = trackOptions.copyWith(volume: volume, isMute: false);

    await _playlist.player.setVolume(volume * 100);
    notifyListeners();
    return true;
  }

  @override
  InstrumentLibrary? get instrumentLibrary => library;

  @override
  bool get useGlobalScale => true;
  SoundBlendGlobalOptions? lastGlobalOptions;
  @override
  Future<bool> updateFromGlobal(SoundBlendGlobalOptions? globalOptions) async {
    if (globalOptions != null) {
      lastGlobalOptions = globalOptions;
    } else if (lastGlobalOptions != null) {
      globalOptions = lastGlobalOptions;
    } else {
      return false;
    }
    if (library == null) return false;
    var raagFiles = library!.raagFiles[selectedRaag];
    if (raagFiles == null) return false;
    var validFiles = raagFiles
        .where((file) => file.noteInRange(globalOptions!.note))
        .toList();
    var beforePlaying = isPlaying;
    if (validFiles.isEmpty) {
      isPlaying = false;
      notifyListeners();
      await updatePlaylist(validFiles);
      return false;
    } else {
      await updatePlaylist(validFiles);
      MusicNote originalNote = validFiles.first.originalScale.note;

      double semitonesDifference = globalOptions!.pitch / 100;
      if (originalNote != globalOptions.note) {
        var notesRange = validFiles.first.noteRange();
        var originalIndex = notesRange.indexOf(originalNote);
        var index = notesRange.indexOf(globalOptions.note);
        semitonesDifference += (index - originalIndex).toDouble();
      }

      var pitchFactor = AudioHelper.semitonesToPitchFactor(semitonesDifference);

      await _playlist.player.setPitch(pitchFactor);
    }
    if (beforePlaying) {
      await _playlist.player.play();
    }
    return true;
  }

  Future<bool> selectRaag(
      {required String raag,
      required SoundBlendGlobalOptions globalOptions}) async {
    selectedRaag = raag;
    await updateFromGlobal(globalOptions);
    notifyListeners();
    return true;
  }

  Future<bool> updatePlaylist(List<SwarmandalFile> files) async {
    if (library != null) {
      await _playlist.resetPlaylist();
      await _playlist.addFiles(files);
      return true;
    }
    return false;
  }

  Future<bool> toggleShuffle() async {
    isShuffle = !isShuffle;
    await _playlist.player.setShuffle(isShuffle);
    _playlist.isShuffle = isShuffle;
    notifyListeners();
    return true;
  }

  @override
  Future<void> resetPlaylist() async {
    for (var element in playlists) {
      element.resetPlaylist();
    }
  }
}
