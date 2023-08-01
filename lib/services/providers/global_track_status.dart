import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';

class GlobalTrackStatus extends ChangeNotifier {
  GlobalTrackStatus({this.isPlaying = false});

  bool isPlaying;

  List<TrackPlaylistsStatus> playlistsStatus = [
    TrackPlaylistsStatus(),
    TrackPlaylistsStatus(),
    TrackPlaylistsStatus(),
    TrackPlaylistsStatus(),
    TrackPlaylistsStatus(),
    TrackPlaylistsStatus(),
  ];
  void play() {
    bool playing = false;
    List<Future<void> Function()> futures = [];
    for (var playlistStatus in playlistsStatus) {
      if (playlistStatus.options.isTrackOn) {
        var result = playlistStatus.play();
        futures.addAll(result);
        if (result.isNotEmpty) {
          playing = true;
        }
      }
    }
    for (var element in futures) {
      element();
    }

    isPlaying = playing;
    notifyListeners();
  }

  void stop() {
    for (var playlistStatus in playlistsStatus) {
      if (playlistStatus.options.isTrackOn) {
        playlistStatus.stop();
      }
    }
    isPlaying = false;
    notifyListeners();
  }

  void updateIsPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void setTempo(double val) {
    for (var playlistStatus in playlistsStatus) {
      if (playlistStatus.options.useGlobalTempo) {
        playlistStatus.setTempo(val);
      }
    }
  }

  void setPitch(double val) {
    try {
      for (var playlistStatus in playlistsStatus) {
        if (playlistStatus.options.useGlobalPitch) {
          playlistStatus.setPitch(val);
        }
      }
    } catch (e) {
      // print(e);
    }
  }

  void clearTracks() {
    for (var playlistStatus in playlistsStatus) {
      playlistStatus.clearPlaylists();
    }

    stop();
  }
}
