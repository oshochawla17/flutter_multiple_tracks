import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/instrument_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/metronome_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/swarmandal_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tabla_track.dart';
import 'package:flutter_multiple_tracks/services/providers/interfaces/tanpura_track.dart';

class GlobalTrackStatus extends ChangeNotifier {
  GlobalTrackStatus({this.isPlaying = false});

  bool isPlaying;

  List<InstrumentTrack> instruments = [
    TanpuraTrack(instrument: Instruments.tanpura1),
    TanpuraTrack(instrument: Instruments.tanpura2),
    TablaPakhawajTrack.tabla(),
    TablaPakhawajTrack.pakhawaj(),
    SwarmandalTrack(),
    MetronomeTrack(),
  ];
  void load(Map<Instruments, InstrumentLibrary> libraries) {
    for (var instrument in instruments) {
      instrument.load(libraries[instrument.instrument]!);
    }
  }

  void play() async {
    // List<Future<void> Function()> futures = [];
    for (var instrument in instruments) {
      if (instrument.trackOptions.isTrackOn) {
        // var result = instrument.play();
        // futures.addAll(result);
        // if (result.isNotEmpty) {
        //   playing = true;
        // }
        instrument.play().then((value) {
          if (value && !isPlaying) {
            isPlaying = true;
            notifyListeners();
          }
        });
      }
    }
    // for (var element in futures) {
    //   element();
    // }

    notifyListeners();
  }

  void stop() {
    for (var playlistStatus in instruments) {
      if (playlistStatus.trackOptions.isTrackOn) {
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

  void setTempo(SoundBlendGlobalOptions globalOptions) {
    for (var instrument in instruments) {
      if (instrument.trackOptions.useGlobalTempo) {
        instrument.updateFromGlobal(globalOptions);
      }
    }
  }

  void setPitch(SoundBlendGlobalOptions globalOptions) {
    try {
      for (var instrument in instruments) {
        if (instrument.trackOptions.useGlobalPitch) {
          instrument.setPitch(globalOptions.pitch, globalOptions);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void updateFromGlobal(SoundBlendGlobalOptions globalOptions) {
    try {
      for (var instrument in instruments) {
        instrument.updateFromGlobal(globalOptions);
      }
    } catch (e) {
      print(e);
    }
  }

  void updateTaal(SoundBlendGlobalOptions globalOptions) {
    try {
      for (var instrument in instruments) {
        if (instrument is MetronomeTrack) {
          instrument.updateFromGlobal(globalOptions);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void updateScale(SoundBlendGlobalOptions globalOptions) {
    try {
      for (var instrument in instruments) {
        if (instrument.useGlobalScale) {
          instrument.updateFromGlobal(globalOptions);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void clearTracks() {
    for (var instrument in instruments) {
      instrument.resetPlaylist();
    }

    stop();
  }
}
