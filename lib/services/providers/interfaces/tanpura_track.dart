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
import 'package:flutter_multiple_tracks/utils/helper.dart';

class TanpuraTrack with ChangeNotifier implements InstrumentTrack {
  TanpuraTrack(
      {this.trackOptions = const TrackOptions(
        isTrackOn: true,
        useGlobalPitch: true,
        useGlobalTempo: false,
        volume: 1.0,
        isMute: false,
        pitch: TrackOptions.defaultPitch,
        tempo: 90,
      ),
      required this.instrument});

  factory TanpuraTrack.tabla() {
    return TanpuraTrack(instrument: Instruments.tabla);
  }
  factory TanpuraTrack.pakhawaj() {
    return TanpuraTrack(instrument: Instruments.pakhawaj);
  }

  final TrackPlaylist _playlist = TrackPlaylist();

  TanpuraLibrary? library;

  String? selectedSub;

  bool isShuffle = false;

  @override
  bool isPlaying = false;

  @override
  final Instruments instrument;

  @override
  TrackOptions trackOptions;

  @override
  Future<bool> mute() async {
    trackOptions = trackOptions.copyWith(isMute: true);
    await _playlist.player.setVolume(0);
    notifyListeners();
    return true;
  }

  // @override
  // List<Future<void> Function()> play() {
  //   List<Future<void> Function()> futures = [];

  //   for (var playlist in playlists) {
  //     if (playlist.selectedFiles.isEmpty) continue;
  //     futures.add(playlist.player.play);
  //   }
  //   return futures;
  // }
  @override
  // List<Future<void> Function()> play() {
  Future<bool> play() async {
    // List<Future<void> Function()> futures = [];
    trackOptions = trackOptions.copyWith(isTrackOn: true);
    var playing = false;
    for (var playlist in playlists) {
      if (playlist.selectedFiles().isEmpty) continue;
      await playlist.player.play();
      playing = true;
    }
    notifyListeners();
    return playing;
  }

  @override
  Future<bool> stop() async {
    await _playlist.resetPlaylist();

    return true;
  }

  @override
  void load(InstrumentLibrary library) {
    this.library = library as TanpuraLibrary;
    if (library.subfiles.isNotEmpty) {
      selectedSub = library.subfiles.keys.first;
    }

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
  Future<bool> updateFromGlobalOptionsAndFiles({
    required SoundBlendGlobalOptions globalOptions,
    required List<TanpuraFile> validFiles,
  }) async {
    var beforePlaying = isPlaying;
    if (validFiles.isEmpty) {
      await updatePlaylist(validFiles);
    } else {
      await updatePlaylist(validFiles);
      MusicNote originalNote = validFiles.first.originalScale.note;
      int originalTempo = validFiles.first.originalTempo;

      double semitonesDifference = globalOptions.pitch / 100;
      if (originalNote != globalOptions.note) {
        var notesRange = validFiles.first.noteRange();
        var originalIndex = notesRange.indexOf(originalNote);
        var index = notesRange.indexOf(globalOptions.note);
        semitonesDifference += (index - originalIndex).toDouble();
      }
      var pitchFactor = AudioHelper.semitonesToPitchFactor(semitonesDifference);
      await _playlist.player.setPitch(pitchFactor);
      await _playlist.player.setRate(trackOptions.tempo! / originalTempo);
    }
    if (beforePlaying) {
      await _playlist.player.play();
    }
    return true;
  }

  @override
  Future<bool> updateFromGlobal(SoundBlendGlobalOptions globalOptions) async {
    if (library == null) return false;
    var taalFiles = library!.subfiles[selectedSub];
    if (taalFiles == null) return false;
    var validFiles = taalFiles
        .where((file) =>
            file.noteInRange(globalOptions.note) &&
            file.tempoInRange(trackOptions.tempo!))
        .toList();
    return await updateFromGlobalOptionsAndFiles(
      globalOptions: globalOptions,
      validFiles: validFiles,
    );
  }

  Future<bool> selectTaal(
      {required String taal,
      required SoundBlendGlobalOptions globalOptions}) async {
    selectedSub = taal;
    await updateFromGlobal(globalOptions);
    notifyListeners();
    return true;
  }

  Future<bool> updatePlaylist(List<TanpuraFile> files) async {
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
