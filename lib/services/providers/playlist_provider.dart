import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:just_audio/just_audio.dart';

class TrackPlaylistsStatus extends ChangeNotifier {
  bool isPlaying;
  TrackPlaylistsStatus({this.isPlaying = false});
  List<TrackPlaylist> playlists = [
    TrackPlaylist(),
    TrackPlaylist(),
    TrackPlaylist(),
    TrackPlaylist(),
  ];
  TrackOptions options = const TrackOptions(
    isTrackOn: true,
    useGlobalPitch: true,
    useGlobalTempo: true,
    volume: 0.5,
  );

  void updateOptions(TrackOptions options) {
    this.options = options;
    notifyListeners();
  }

  bool play() {
    bool playing = false;
    for (var playlist in playlists) {
      if (playlist.files.isEmpty) continue;
      playing = true;
      isPlaying = true;
      playlist.player.play();
    }
    notifyListeners();
    return playing;
  }

  void pause() {
    for (var playlist in playlists) {
      playlist.player.pause();
    }
    isPlaying = false;
    notifyListeners();
  }

  void setVolume(double volume) {
    for (var playlist in playlists) {
      playlist.player.setVolume(volume);
    }
    options = options.copyWith(volume: volume);
    notifyListeners();
  }
}

class TrackPlaylist {
  TrackPlaylist() {
    load();
  }

  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  AudioPlayer player = AudioPlayer();

  List<String> files = [];

  void load() async {
    await player.setAudioSource(playlist);
    await player.setLoopMode(LoopMode.all);
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  void addFile(String filePath) {
    playlist.add(AudioSource.file(filePath));
    files.add(filePath);
  }

  void removeFile(String file) {
    if (files.isEmpty) return;
    playlist.removeAt(files.indexOf(file));
    files.remove(file);
    if (files.isEmpty) {
      player.stop();
    }
  }
}
