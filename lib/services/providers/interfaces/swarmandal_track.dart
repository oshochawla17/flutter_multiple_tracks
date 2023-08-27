import 'dart:async';
import 'dart:math';

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
    trackOptions = trackOptions.copyWith(isTrackOn: true);
    var resullt = await updateFromGlobal(null);
    if (!resullt) {
      isPlaying = false;
      notifyListeners();
      return false;
    }
    await _playlist.player.play();
    notifyListeners();
    return resullt;
  }

  Timer? timer;
  bool stopPlaying = false;

  @override
  Future<bool> stop() async {
    await _playlist.resetPlaylist();
    return true;
  }

  int calculateTime() {
    var options = trackOptions as SwarmandalTrackOptions;
    if (options.useRandomInterval &&
        options.randomIntervalsRange.length == 2 &&
        options.randomIntervalsRange[0] != null &&
        options.randomIntervalsRange[1] != null &&
        options.randomIntervalsRange[1]! >= options.randomIntervalsRange[0]!) {
      var random = Random();
      var randomIntervalsRange = options.randomIntervalsRange;
      var randomIntervals = randomIntervalsRange[0]! +
          random.nextInt(randomIntervalsRange[1]! - randomIntervalsRange[0]!);
      return randomIntervals * 1000;
    } else {
      return (options.gaps ?? 3) * 1000;
    }
  }

  @override
  void load(InstrumentLibrary library) {
    this.library = library as SwarmandalLibrary;
    if (library.raagFiles.isNotEmpty) {
      selectedRaag = library.raagFiles.keys.first;
    }

    _playlist.player.stream.completed.listen((event) async {
      if (event) {
        timer?.cancel();
        await _playlist.player.pause();
        var milliseconds = calculateTime();
        print('milliseconds: $milliseconds');
        timer = Timer(Duration(milliseconds: milliseconds), () async {
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
    // _playlist.player.stream.playing.listen((event) {
    //   if (isPlaying != event) {
    //     isPlaying = event;

    //     notifyListeners();
    //   }
    // });
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
