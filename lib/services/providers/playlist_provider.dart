import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/playlists_file.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:media_kit/media_kit.dart';
// import 'package:just_audio/just_audio.dart';

class MyPlaylist {
  void add() {}
  void removeAtIndex(int index) {}
}

class TrackPlaylistsStatus extends ChangeNotifier {
  TrackPlaylistsStatus({this.isPlaying = false});

  bool isPlaying;

  TrackOptions options = const TrackOptions(
    isTrackOn: true,
    useGlobalPitch: true,
    useGlobalTempo: true,
    volume: 1.0,
    isMute: false,
    pitch: 0,
    tempo: 1,
  );

  List<TrackPlaylist> playlists = [
    TrackPlaylist(),
    TrackPlaylist(),
    TrackPlaylist(),
    TrackPlaylist(),
  ];

  void updateOptions(TrackOptions options) {
    this.options = options;
    notifyListeners();
  }

  List<Future<void> Function()> play() {
    List<Future<void> Function()> futures = [];

    for (var playlist in playlists) {
      if (playlist.files.isEmpty) continue;
      isPlaying = true;
      futures.add(playlist.player.play);
      // playlist.player.play();
    }
    notifyListeners();
    return futures;
  }

  Future<void> stop() async {
    for (var playlist in playlists) {
      handleStop(playlist);
    }
    isPlaying = false;
    notifyListeners();
  }

  Future<void> handleStop(TrackPlaylist playlist) async {
    await playlist.player.jump(0);
    await playlist.player.pause();
    // playlist.player.setAudioSource(playlist.playlist);
  }

  void setVolume(double volume) {
    if (options.isMute) options = options.copyWith(isMute: false);
    for (var playlist in playlists) {
      playlist.player.setVolume(volume * 100);
    }
    options = options.copyWith(volume: volume);
    notifyListeners();
  }

  void mute() {
    options = options.copyWith(isMute: true);

    for (var playlist in playlists) {
      playlist.player.setVolume(0);
    }
    notifyListeners();
  }

  void unmute() {
    options = options.copyWith(isMute: false);
    for (var playlist in playlists) {
      playlist.player.setVolume(options.volume);
    }
    notifyListeners();
  }

  void setTempo(double val) {
    for (var playlist in playlists) {
      playlist.player.setRate(val);
    }
  }

  void setPitch(double val) {
    try {
      double factor = calculatePitchFactor(val);
      for (var playlist in playlists) {
        playlist.player.setPitch(factor);
      }
    } catch (e) {
      // print(e);
    }
  }

  void clearPlaylists() {
    try {
      for (var playlist in playlists) {
        playlist.player.stop();
        // playlist.playlist.clear();
        // playlist.player.
        playlist.files.clear();
      }
    } catch (e) {
      // print(e);
    }
  }

  double calculatePitchFactor(double semitones) {
    return pow(2, semitones / 12) as double;
  }
}

class TrackPlaylist {
  TrackPlaylist() {
    load();
  }

  // ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
  //   useLazyPreparation: true,
  //   shuffleOrder: DefaultShuffleOrder(),
  //   children: [],
  // );

  // AudioPlayer player = AudioPlayer();
  final Player player = Player(
      configuration: const PlayerConfiguration(
    pitch: true,
  ));

  List<PlaylistFile> files = [];

  void load() async {
    await player.setPlaylistMode(
      PlaylistMode.loop,
    );
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  Playlist playlist = Playlist([]);
  void addFile(PlaylistFile file) async {
    // playlist.add(AudioSource.uri(Uri.file(file.path)));
    // await player.add(Media(file.path));
    player.open(Playlist([...player.state.playlist.medias, Media(file.path)]),
        play: player.state.playing);
    if (player.state.playlist.medias.isEmpty) {
      // await player.open(Playlist([Media(file.path)]), play: false);
    } else {
      // await player.add(Media(file.path));
    }

    files.add(file);
  }

  void removeFile(PlaylistFile file) {
    if (files.isEmpty) return;
    // playlist.removeAt(files.indexOf(file));
    player.remove(files.indexOf(file));
    files.remove(file);
    if (files.isEmpty) {
      player.stop();
    }
  }
}
