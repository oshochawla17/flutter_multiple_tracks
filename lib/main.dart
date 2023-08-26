import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/screens/demo_home.dart';
import 'package:flutter_multiple_tracks/screens/sound_blend_home.dart';
import 'package:media_kit/media_kit.dart';

class FFIBridge {
  static bool initialize() {
    return true;
  }
}

void main() {
  // traverseDirectory();
  MediaKit.ensureInitialized();
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
