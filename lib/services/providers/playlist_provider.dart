import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:media_kit/media_kit.dart';

// class TrackPlaylistsStatus extends ChangeNotifier {
//   TrackPlaylistsStatus({this.isPlaying = false});

//   bool isPlaying;

//   TrackOptions options = const TrackOptions(
//     isTrackOn: true,
//     useGlobalPitch: true,
//     useGlobalTempo: true,
//     volume: 1.0,
//     isMute: false,
//     pitch: 0,
//     tempo: 60,
//   );

//   List<TrackPlaylist> playlists = [
//     TrackPlaylist(),
//     TrackPlaylist(),
//     TrackPlaylist(),
//     TrackPlaylist(),
//   ];

//   void updateOptions(TrackOptions options) {
//     this.options = options;
//     notifyListeners();
//   }

//   List<Future<void> Function()> play() {
//     List<Future<void> Function()> futures = [];

//     for (var playlist in playlists) {
//       if (playlist.files.isEmpty) continue;
//       isPlaying = true;
//       futures.add(playlist.player.play);
//     }
//     notifyListeners();
//     return futures;
//   }

//   Future<void> stop() async {
//     for (var playlist in playlists) {
//       handleStop(playlist);
//     }
//     isPlaying = false;
//     notifyListeners();
//   }

//   Future<void> handleStop(TrackPlaylist playlist) async {
//     if (playlist.player.state.playlist.medias.isNotEmpty) {
//       await playlist.player.jump(0);
//       await playlist.player.pause();
//     }
//   }

//   void setVolume(double volume) {
//     if (options.isMute) options = options.copyWith(isMute: false);
//     for (var playlist in playlists) {
//       playlist.player.setVolume(volume * 100);
//     }
//     options = options.copyWith(volume: volume);
//     notifyListeners();
//   }

//   void mute() {
//     options = options.copyWith(isMute: true);

//     for (var playlist in playlists) {
//       playlist.player.setVolume(0);
//     }
//     notifyListeners();
//   }

//   void unmute() {
//     options = options.copyWith(isMute: false);
//     for (var playlist in playlists) {
//       playlist.player.setVolume(options.volume);
//     }
//     notifyListeners();
//   }

//   void setTempo(double val) {
//     for (var playlist in playlists) {
//       playlist.player.setRate(val);
//     }
//   }

//   void setPitch(double cents) {
//     try {
//       double factor = AudioHelper.semitonesToPitchFactor(cents / 100);
//       for (var playlist in playlists) {
//         playlist.player.setPitch(factor);
//       }
//     } catch (e) {
//       // print(e);
//     }
//   }

//   void clearPlaylists() {
//     try {
//       for (var playlist in playlists) {
//         playlist.player.stop();
//         // playlist.playlist.clear();
//         // playlist.player.
//         playlist.files.clear();
//       }
//     } catch (e) {
//       // print(e);
//     }
//   }
// }

class TrackPlaylist {
  TrackPlaylist({this.useLoop = true}) {
    load();
  }
  final bool useLoop;
  // ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
  //   useLazyPreparation: true,
  //   shuffleOrder: DefaultShuffleOrder(),
  //   children: [],
  // );

  // AudioPlayer player = AudioPlayer();
  Player player = Player(
      configuration: const PlayerConfiguration(
    pitch: true,
  ));

  List<InstrumentFile> files = [];

  void load() async {
    await player
        .setPlaylistMode(useLoop ? PlaylistMode.loop : PlaylistMode.single);
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  Future<void> addFile(InstrumentFile file) async {
    await player.open(
        Playlist([
          ...player.state.playlist.medias,
          Media(file.path, extras: {'file': file})
        ]),
        play: player.state.playing);
  }

  Future<void> addFiles(List<InstrumentFile> newFiles) async {
    if (newFiles.isEmpty) return;
    await player.open(
        Playlist([
          ...player.state.playlist.medias,
          ...newFiles.map((e) => Media(e.path, extras: {'file': e}))
        ]),
        play: player.state.playing);

    files.addAll(newFiles);
  }

  void removeFile(InstrumentFile file) {
    if (files.isEmpty) return;
    player.remove(files.indexOf(file));
    files.remove(file);
    if (files.isEmpty) {
      player.stop();
    }
  }

  Future<void> clearPlaylist() async {
    await player.stop();
    files.clear();
    return;
  }

  Future<bool> selectFile(InstrumentFile file) async {
    if (file.isSelected) return false;
    var matchedFile = files.indexOf(file);
    if (matchedFile == -1) {
      return false;
    } else {
      addFile(file.copyWith(isSelected: true));
      files[matchedFile] = file.copyWith(isSelected: true);
    }
    return true;
  }

  Future<bool> unslectFile(InstrumentFile file) async {
    if (!file.isSelected) return false;
    var matchedFileIndex = files.indexOf(file);
    print('matchedFileIndex: $matchedFileIndex');
    if (matchedFileIndex == -1) {
      return false;
    } else {
      var index = player.state.playlist.medias
          .indexWhere((element) => element.uri == file.path);
      print('index: $index');
      var currentMedia = player.state.playlist.medias;
      var newMedia = [
        ...currentMedia.sublist(0, index),
        ...currentMedia.sublist(index + 1)
      ];
      print(newMedia);

      await player.remove(index);
      Future.delayed(Duration(milliseconds: 100), () async {
        await player.open(Playlist(newMedia), play: player.state.playing);
      });

      print(player.state.playlist.medias);
      files[matchedFileIndex] = file.copyWith(isSelected: false);
    }
    return true;
  }
}
