import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tanpura_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tanpura_library.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';

class TanpuraTrack with ChangeNotifier implements InstrumentTrack {
  TanpuraTrack(
      {this.trackOptions = const TrackOptions(
        isTrackOn: true,
        useGlobalPitch: false,
        useGlobalTempo: false,
        volume: 1.0,
        isMute: false,
        pitch: TrackOptions.defaultPitch,
        tempo: 90,
      )});

  final List<TrackPlaylist> _playlists = [
    TrackPlaylist(useLoop: false),
    TrackPlaylist(useLoop: false),
    TrackPlaylist(useLoop: false),
    TrackPlaylist(useLoop: false)
  ];

  TanpuraLibrary? library;
  Scale? chosenScale;

  @override
  final Instruments instrument = Instruments.tanpura;

  @override
  TanpuraFile? currentPlaying;

  @override
  bool isPlaying = false;

  @override
  TrackOptions trackOptions;

  @override
  InstrumentLibrary? get instrumentLibrary => library;

  @override
  bool get useGlobalScale => true;

  @override
  Future<bool> mute() async {
    trackOptions = trackOptions.copyWith(isMute: true);
    for (var playlist in _playlists) {
      playlist.player.setVolume(0);
    }

    notifyListeners();
    return true;
  }

  bool lock = false;
  Future<bool> setTempo(tempo) async {
    if (lock) return false;
    lock = true;
    var beforePlaying = isPlaying;
    print('changing tempo to $tempo');
    timer?.cancel();
    for (var playlist in _playlists) {
      await stopPlaylist(playlist);
    }
    if (beforePlaying) {
      stopPlaying = false;
      await playTracksWithDelay();
    }
    lock = false;
    return true;
  }

  // @override
  // List<Future<void> Function()> play() {
  //   stopPlaying = false;
  //   List<Future<void> Function()> futures = [];
  //   futures.add(playTracksWithDelay);

  //   return futures;
  // }
  @override
  // List<Future<void> Function()> play() {
  Future<bool> play() async {
    stopPlaying = false;
    var result = await playTracksWithDelay();
    isPlaying = result;
    notifyListeners();
    return result;
  }

  List<Scale> availableNotes() {
    var notes = library?.files.map((e) => e.originalScale).toSet().toList();
    notes?.sort((Scale a, Scale b) {
      return a.toString().compareTo(b.toString());
    });
    return notes ?? [];
  }

  Timer? timer;
  Future<bool> playTracksWithDelay() async {
    int milliseconds = 60000 ~/ trackOptions.tempo!;
    bool play = await restartPlaylist(playlists[0]);
    if (!play) return false;
    int currentIndex = 1;
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      if (stopPlaying) {
        timer.cancel();
        return;
      }
      restartPlaylist(playlists[currentIndex]);
      if (currentIndex == playlists.length - 1) {
        timer.cancel();
        Future.delayed(Duration(milliseconds: milliseconds * 2), () {
          playTracksWithDelay();
        });
      }
      currentIndex++;
      if (currentIndex >= playlists.length) {
        currentIndex = 0;
      }
    });

    if (stopPlaying) {
      timer?.cancel();
      return false;
    }
    return true;
    // for (int index = 0; index < playlists.length; index++) {
    //   var playlist = playlists[index];
    //   if (stopPlaying) {
    //     stopPlaying = false;
    //     return;
    //   }
    //   restartPlaylist(playlist);
    //   if (index < playlists.length - 1) {
    //     print(
    //         'waiting for $milliseconds milliseconds after playlist: ${index + 1}');

    //     await Future.delayed(Duration(milliseconds: milliseconds));
    //   }
    // }
    // print('waiting for ${milliseconds * 2} milliseconds after playlist: 4');

    // await Future.delayed(Duration(milliseconds: 2 * milliseconds));
    // playTracksWithDelay();
  }

  bool stopPlaying = false;

  Future<bool> stopPlaylist(TrackPlaylist playlist) async {
    stopPlaying = true;
    await playlist.resetPlaylist();
    return true;
  }

  Future<bool> restartPlaylist(TrackPlaylist playlist) async {
    if (stopPlaying) return false;
    if (playlist.player.state.playing) {
      await playlist.resetPlaylist();
    } else {
      await playlist.player.play();
    }
    return true;
  }

  @override
  Future<bool> stop() async {
    timer?.cancel();
    for (var playlist in _playlists) {
      stopPlaylist(playlist);
    }
    isPlaying = false;
    notifyListeners();
    return true;
  }

  @override
  void load(InstrumentLibrary library) {
    this.library = library as TanpuraLibrary;

    // playlists[0].player.stream.playing.listen((event) {
    //   isPlaying = event;
    //   print('setting isPlaying to $event');
    //   notifyListeners();
    // });
  }

  @override
  bool updateFromLocal(TrackOptions localOptions) {
    trackOptions = localOptions;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> setPitch(int cents) async {
    throw UnimplementedError();
  }

  @override
  List<TrackPlaylist> get playlists => _playlists;

  @override
  Future<bool> unmute() async {
    trackOptions = trackOptions.copyWith(isMute: false);
    for (var playlist in _playlists) {
      playlist.player.setVolume(trackOptions.volume * 100);
    }
    notifyListeners();
    return true;
  }

  @override
  Future<bool> setVolume(double volume) async {
    trackOptions = trackOptions.copyWith(volume: volume, isMute: false);

    for (var playlist in _playlists) {
      playlist.player.setVolume(volume * 100);
    }
    notifyListeners();
    return true;
  }

  Future<bool> updatePlaylist(
      TrackPlaylist playlist, List<TanpuraFile> files) async {
    if (library != null) {
      await playlist.resetPlaylist();
      await playlist.addFiles(files);
      return true;
    }
    return false;
  }

  Future<bool> updatePlaylist1Scale(
      Scale? scale, SoundBlendGlobalOptions globalOptions) async {
    if (scale != null) {
      if (library != null) {
        chosenScale = scale;
        var result = await updateFromGlobalWithScale(globalOptions, scale);
        if (!result) {
          isPlaying = false;
        }
        notifyListeners();
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Future<bool> updateFromGlobal(SoundBlendGlobalOptions globalOptions) async {
    chosenScale = null;
    var result = await updateFromGlobalWithScale(globalOptions, chosenScale);
    isPlaying = result;
    notifyListeners();
    return result;
  }

  Future<bool> updateFromGlobalWithScale(
      SoundBlendGlobalOptions globalOptions, Scale? scale) async {
    var beforePlaying = isPlaying;
    stopPlaying = true;
    if (library == null) return false;

    List<List<TanpuraFile>> validPlaylistFiles = [
      [],
      [],
      [],
      [],
    ];

    var validNote = globalOptions.note;
    Scale playlist3Scale =
        Scale(note: validNote, octave: validNote == MusicNote.B ? 3 : 4);
    Scale playlist1Scale = scale ?? playlist3Scale.subtract(5);
    print(playlist1Scale.toString());
    var validScales = [
      playlist1Scale,
      playlist3Scale,
      playlist3Scale,
      Scale(note: validNote, octave: validNote == MusicNote.B ? 2 : 3),
    ];
    for (var file in library!.files) {
      var fileScale = file.originalScale;

      for (var i = 0; i < validScales.length; i++) {
        if (fileScale == validScales[i]) {
          validPlaylistFiles[i].add(file);
        }
      }
    }

    for (var i = 0; i < validPlaylistFiles.length; i++) {
      var result = await updatePlaylist(playlists[i], validPlaylistFiles[i]);
      if (!result) return false;
    }
    if (beforePlaying) {
      var result = await playTracksWithDelay();
      return result;
    }
    return beforePlaying;
  }

  @override
  Future<void> resetPlaylist() async {
    for (var element in playlists) {
      element.resetPlaylist();
    }
  }
}
