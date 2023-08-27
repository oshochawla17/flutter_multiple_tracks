import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/screens/sound_blend_home.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FFIBridge {
  static bool initialize() {
    return true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();
  FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Blend',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: const SoundBlendHome(),
      // home: HomePage(),
    );
  }
}
