import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:media_kit/media_kit.dart';

class TrackPlaylist {
  TrackPlaylist({this.useLoop = true}) {
    load();
  }
  final bool useLoop;

  Player player = Player(
      configuration: const PlayerConfiguration(
    pitch: true,
  ));

  List<InstrumentFile> files = [];

  void load() async {
    await player
        .setPlaylistMode(useLoop ? PlaylistMode.loop : PlaylistMode.none);
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  List<InstrumentFile> get selectedFiles {
    return files.where((element) => element.isSelected).toList();
  }

  List<Media> get selectedMediaFiles {
    return selectedFiles
        .map((e) => Media(
              e.path,
            ))
        .toList();
  }

  Future<void> addFile(InstrumentFile file) async {
    await player.open(
        Playlist([
          ...selectedMediaFiles,
          Media(
            file.path,
          )
        ]),
        play: player.state.playing);
  }

  Future<void> addFiles(List<InstrumentFile> newFiles) async {
    var filesCopy = [...newFiles];
    if (filesCopy.isEmpty) {
      await player.stop();
    } else {
      await player.open(
          Playlist(filesCopy
              .map((e) => Media(
                    e.path,
                  ))
              .toList()),
          play: player.state.playing);
    }

    files = filesCopy;
  }

  Future<void> resetPlaylist() async {
    if (selectedFiles.isEmpty) {
      await player.stop();
      return;
    }
    await player.stop();
    await player.open(
        Playlist([
          ...selectedMediaFiles,
        ]),
        play: player.state.playing);
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

  Future<bool> unselectFile(InstrumentFile file) async {
    if (!file.isSelected) return false;
    var matchedFileIndex = files.indexOf(file);
    if (matchedFileIndex == -1) {
      return false;
    } else {
      var newPlaylist = files
          .where((element) => element.isSelected && element.path != file.path)
          .map((e) => Media(e.path))
          .toList();
      if (newPlaylist.isEmpty) {
        await player.stop();
      } else {
        await player.open(Playlist(newPlaylist), play: player.state.playing);
      }

      files[matchedFileIndex] = file.copyWith(isSelected: false);
    }
    return true;
  }
}
