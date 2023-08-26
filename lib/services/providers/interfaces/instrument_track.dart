import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instruments_library.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/models/track_options.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';

abstract class InstrumentTrack with ChangeNotifier {
  Instruments get instrument;
  bool isPlaying = false;
  bool get useGlobalScale;
  List<TrackPlaylist> get playlists;
  InstrumentLibrary? get instrumentLibrary;
  late TrackOptions trackOptions;
  // List<Future<void> Function()> play();
  Future<bool> play();
  Future<bool> stop();
  Future<bool> mute();
  Future<bool> unmute();
  Future<bool> setVolume(double volume);
  Future<bool> updateFromGlobal(SoundBlendGlobalOptions globalOptions);

  bool updateFromLocal(TrackOptions localOptions);
  void load(InstrumentLibrary library);
  Future<void> resetPlaylist();
  Future<bool> setPitch(int cents, SoundBlendGlobalOptions globalOptions);

  InstrumentFile? get currentPlaying;
}
