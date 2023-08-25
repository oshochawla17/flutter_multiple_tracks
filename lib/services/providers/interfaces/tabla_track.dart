import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/tabla_pakhawaj_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/tabla_pakhawaj_library.dart';
import 'package:flutter_multiple_tracks/services/models/music_scales.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:flutter_multiple_tracks/utils/helper.dart';
import 'package:media_kit/media_kit.dart';

class TablaPakhawajTrack with ChangeNotifier implements InstrumentTrack {
  TablaPakhawajTrack(
      {this.trackOptions = const TrackOptions(
        isTrackOn: true,
        useGlobalPitch: true,
        useGlobalTempo: true,
        volume: 1.0,
        isMute: false,
        pitch: TrackOptions.defaultPitch,
        tempo: TrackOptions.defaultTempo,
      ),
      required this.instrument});

  factory TablaPakhawajTrack.tabla() {
    return TablaPakhawajTrack(instrument: Instruments.tabla);
  }
  factory TablaPakhawajTrack.pakhawaj() {
    return TablaPakhawajTrack(instrument: Instruments.pakhawaj);
  }

  final TrackPlaylist _playlist = TrackPlaylist();

  TablaPakhawajLibrary? library;

  String? selectedTaal;

  bool isShuffle = false;

  List<Media> get mediaFiles => _playlist.player.state.playlist.medias;

  @override
  TablaPakhawajFile? currentPlaying;

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

  @override
  Future<bool> resetPlaylist() {
    throw UnimplementedError();
  }

  @override
  List<Future<void> Function()> play() {
    List<Future<void> Function()> futures = [];

    for (var playlist in playlists) {
      if (mediaFiles.isEmpty) continue;
      futures.add(playlist.player.play);
    }
    return futures;
  }

  // @override
  // PlayerStream get playerStream {
  //   return _playlist.player.stream;
  // }

  @override
  Future<bool> stop() async {
    if (_playlist.player.state.playlist.medias.isEmpty) {
      await _playlist.player.stop();
      return true;
    } else {
      var currentFiles = _playlist.player.state.playlist.medias
          .map((e) => e.extras?['file'] as TablaPakhawajFile)
          .toList();

      await _playlist.clearPlaylist();
      await _playlist.addFiles(currentFiles);

      return true;
    }
  }

  @override
  void load(InstrumentLibrary library) {
    this.library = library as TablaPakhawajLibrary;
    if (library.taalFiles.isNotEmpty) {
      selectedTaal = library.taalFiles.keys.first;
    }

    _playlist.player.stream.playing.listen((event) {
      isPlaying = event;
      print('setting isPlaying to $event');
      notifyListeners();
    });
    _playlist.player.stream.tracks.listen((event) {
      int index = _playlist.player.state.playlist.index;
      if (index >= _playlist.player.state.playlist.medias.length) {
        currentPlaying = null;
      } else {
        currentPlaying =
            _playlist.player.state.playlist.medias[index].extras?['file'];
      }
      notifyListeners();
    });
  }

  @override
  bool updateFromLocal(TrackOptions localOptions) {
    trackOptions = localOptions;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> setPitch(int cents) async {
    await _playlist.player
        .setPitch(AudioHelper.semitonesToPitchFactor(cents / 100));

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
    required List<TablaPakhawajFile> validFiles,
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
      print('semitones difference: $semitonesDifference');
      var pitchFactor = AudioHelper.semitonesToPitchFactor(semitonesDifference);
      print('setting pitch to $pitchFactor');
      await _playlist.player.setPitch(pitchFactor);
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
    var taalFiles = library!.taalFiles[selectedTaal];
    if (taalFiles == null) return false;
    var validFiles = taalFiles
        .where((file) =>
            file.noteInRange(globalOptions.note) &&
            file.tempoInRange(globalOptions.tempo))
        .toList();
    return await updateFromGlobalOptionsAndFiles(
      globalOptions: globalOptions,
      validFiles: validFiles,
    );
  }

  Future<bool> selectTaal(
      {required String taal,
      required SoundBlendGlobalOptions globalOptions}) async {
    selectedTaal = taal;
    await updateFromGlobal(globalOptions);
    notifyListeners();
    return true;
  }

  Future<bool> updatePlaylist(List<TablaPakhawajFile> files) async {
    if (library != null) {
      await _playlist.clearPlaylist();
      await _playlist.addFiles(files);
      return true;
    }
    return false;
  }

  Future<bool> taggleShuffle() async {
    isShuffle = !isShuffle;
    await _playlist.player.setShuffle(isShuffle);
    notifyListeners();
    return true;
  }
}
