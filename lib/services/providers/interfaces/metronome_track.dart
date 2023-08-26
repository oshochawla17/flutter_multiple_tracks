import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/metronome_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/metronome_library.dart.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';

class MetronomeTrack with ChangeNotifier implements InstrumentTrack {
  MetronomeTrack({
    this.trackOptions = const TrackOptions(
      volume: 1.0,
      isMute: false,
      isTrackOn: true,
      useGlobalTempo: true,
      useGlobalPitch: false,
    ),
  });

  final TrackPlaylist _playlist = TrackPlaylist();

  @override
  TrackOptions trackOptions;

  MetronomeLibrary? library;

  @override
  MetronomeFile? currentPlaying;

  @override
  bool isPlaying = false;

  @override
  final Instruments instrument = Instruments.metronome;

  @override
  Future<bool> mute() async {
    trackOptions = trackOptions.copyWith(isMute: true);
    await _playlist.player.setVolume(0);
    notifyListeners();
    return true;
  }

  @override
  // List<Future<void> Function()> play() {
  Future<bool> play() async {
    // List<Future<void> Function()> futures = [];
    var playing = false;
    for (var playlist in playlists) {
      if (playlist.selectedFiles().isEmpty) continue;
      await playlist.player.play();
      playing = true;
    }
    return playing;
  }

  // @override
  // PlayerStream get playerStream {
  //   return _playlist.player.stream;
  // }

  @override
  Future<bool> stop() async {
    await _playlist.resetPlaylist();
    return true;
  }

  @override
  void load(InstrumentLibrary library) {
    this.library = library as MetronomeLibrary;

    _playlist.player.stream.playing.listen((event) {
      isPlaying = event;
      notifyListeners();
    });
    _playlist.player.stream.playlist.listen((event) {
      if (event.medias.isNotEmpty) {
        currentPlaying = _playlist.files.firstWhere(
                (element) => element.path == event.medias[event.index].uri)
            as MetronomeFile;
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
  bool get useGlobalScale => false;

  Future<bool> updateFromGlobalOptionsAndFiles({
    required SoundBlendGlobalOptions globalOptions,
    required List<MetronomeFile> validFiles,
  }) async {
    var beforePlaying = isPlaying;
    if (validFiles.isEmpty) {
      await updatePlaylist(validFiles);
    } else {
      await updatePlaylist(validFiles);

      int originalTempo = validFiles.first.originalTempo;

      await _playlist.player.setRate(globalOptions.tempo / originalTempo);
    }
    if (beforePlaying) {
      await _playlist.player.play();
    }
    return true;
  }

  @override
  Future<bool> updateFromGlobal(SoundBlendGlobalOptions globalOptions) async {
    if (library == null) return false;
    var taalFiles = library!.taalFiles[globalOptions.selectedTaal];
    if (taalFiles == null) return false;
    var validFiles = taalFiles
        .where((file) => file.tempoInRange(globalOptions.tempo))
        .toList();
    return await updateFromGlobalOptionsAndFiles(
      globalOptions: globalOptions,
      validFiles: validFiles,
    );
  }

  Future<bool> updatePlaylist(List<MetronomeFile> files) async {
    if (library != null) {
      await _playlist.resetPlaylist();
      await _playlist.addFiles(files);
      return true;
    }
    return false;
  }

  @override
  Future<void> resetPlaylist() async {
    for (var element in playlists) {
      element.resetPlaylist();
    }
  }
}
