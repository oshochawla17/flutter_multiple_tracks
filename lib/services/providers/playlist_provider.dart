import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter_multiple_tracks/services/models/playlists_file.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
// import 'package:flutter_sequencer/models/instrument.dart';
// import 'package:flutter_sequencer/models/sfz.dart';
// import 'package:flutter_sequencer/sequence.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:audioplayers/audioplayers.dart';

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
    // loadSf2("assets/SFZ/Piano.sf2");
    // return [];
    // // add all plays to futures
    // final instruments = [
    //   // Sf2Instrument(path: "tabla2.sf2", isAsset: true),
    //   SfzInstrument(
    //     path: "assets/SFZ/ektaal.sfz",
    //     isAsset: true,
    //     // tuningPath: "assets/sfz/meanquar.scl",
    //   ),
    //   RuntimeSfzInstrument(
    //     id: "Sampled Synth",
    //     sampleRoot: "assets/SFZ/ektaal_samples",
    //     isAsset: true,
    //     sfz: Sfz(
    //       groups: [
    //         SfzGroup(
    //           regions: [
    //             SfzRegion(
    //               sample: "ektaal_samples.wav",
    //               otherOpcodes: {
    //                 "oscillator_multi": "5",
    //                 "oscillator_detune": "50",
    //               },
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    //   // RuntimeSfzInstrument(
    //   //     id: "Generated Synth",
    //   //     sampleRoot: "/",
    //   //     isAsset: false,
    //   //     sfz: Sfz(groups: [
    //   //       SfzGroup(regions: [
    //   //         SfzRegion(sample: "*saw", otherOpcodes: {
    //   //           "oscillator_multi": "5",
    //   //           "oscillator_detune": "50",
    //   //         })
    //   //       ])
    //   //     ])
    //   //   ),
    // ];
    // final sequence = Sequence(tempo: 100.0, endBeat: 8.0);
    // sequence.createTracks(instruments).then((tracks) {
    //   tracks.forEach((track) {});
    //   sequence.play();
    // });
    // return [];
    List<Future<void> Function()> futures = [];

    for (var playlist in playlists) {
      if (playlist.files.isEmpty) continue;
      isPlaying = true;
      futures.add(playlist.player.play);
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
    await playlist.player.stop();
    playlist.player.setAudioSource(playlist.playlist);
  }

  void setVolume(double volume) {
    if (options.isMute) options = options.copyWith(isMute: false);
    for (var playlist in playlists) {
      playlist.player.setVolume(volume);
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
      playlist.player.setSpeed(val);
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
        playlist.playlist.clear();
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

  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  AudioPlayer player = AudioPlayer();

  List<PlaylistFile> files = [];
  // List<Instrument> instruments = [];
  // final sequence = Sequence(tempo: 100.0, endBeat: 2.0);

  void load() async {
    // await player.setPitch(2);
    await player.setAudioSource(playlist);
    await player.setLoopMode(LoopMode.all);
    await player.setVolume(1);
    // player.audioSource.
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  void addFile(PlaylistFile file) {
    playlist.add(AudioSource.uri(Uri.file(file.path)));
    files.add(file);
    // try {
    //   instruments.add(
    //     Sf2Instrument(
    //       path: file.path,
    //       isAsset: false,
    //     ),
    //   );

    //   sequence.createTracks(instruments);
    // } catch (err) {
    //   // print(err);
    // }
    // instruments.add(RuntimeSfzInstrument(
    //   id: file.name,
    //   isAsset: false,
    //   sampleRoot: '/',
    //   sfz: null,
    // ));
  }

  void removeFile(PlaylistFile file) {
    if (files.isEmpty) return;
    playlist.removeAt(files.indexOf(file));
    files.remove(file);
    if (files.isEmpty) {
      player.stop();
    }
  }
}
