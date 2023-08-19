import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/screens/sound_blend_home.dart';
import 'dart:ffi';

import 'package:media_kit/media_kit.dart';

class FFIBridge {
  static bool initialize() {
    return true;
  }
}

void main() {
  // FFIBridge.initialize();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // final int val = FFIBridge.add(2, 3);
    return MaterialApp(
      title: 'Sound Blend',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: const SoundBlendHome(),
    );
  }
}

// import 'dart:math';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';

// import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
// // import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Necessary initialization for package:media_kit.
//   MediaKit.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       home: MyScreen(),
//     ),
//   );
// }

// class MyScreen extends StatefulWidget {
//   const MyScreen({Key? key}) : super(key: key);
//   @override
//   State<MyScreen> createState() => MyScreenState();
// }

// class MyScreenState extends State<MyScreen> {
//   final Player player = Player(
//       configuration: const PlayerConfiguration(
//     pitch: true,
//   ));
//   double calculatePitchFactor(double semitones) {
//     return pow(2, semitones / 12) as double;
//   }

//   @override
//   void initState() {
//     super.initState();
//     playlist = Playlist([]);
//     player.setPlaylistMode(PlaylistMode.loop).then((value) {});
//     // Future.delayed(Duration(seconds: 10), () {
//     //   double factor = calculatePitchFactor(12);
//     //   player.setPitch(factor);
//     // });
//   }

//   late Playlist playlist;

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   void setPitch() async {
//     double factor = calculatePitchFactor(5);
//     player.setPitch(factor);
//   }

//   void setTempo() async {
//     player.setRate(1.5);
//   }

//   void pickFiles() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       if (result.files.single.path != null) {
//         if (player.state.playlist.medias.isEmpty) {
//           print('empty');
//           player.open(Playlist([Media(result.files.single.path!)]));
//         } else {
//           print(player.state.playlist.medias.length);
//           player.add(Media(result.files.single.path!));
//         }
//         // player.add(Media(result.files.single.path!)).then((value) {
//         //   print(playlist.medias.length);
//         //   player.play();
//         // });
//         // if (playlist.medias.length == 1) {
//         // await player.open(playlist, play: false);
//         // player.play();
//         // }
//         // player
//         //     .open(
//         //         Playlist([
//         //           Media(result.files.single.path!),
//         //           Media(result.files.single.path!)
//         //         ]),
//         //         play: false)
//         //     .then((value) {
//         //   player.play();
//         // });
//       }
//     } else {
//       // User canceled the picker
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.width * 9.0 / 16.0,
//           // Use [Video] widget to display video output.
//           child: Scaffold(
//             body: MaterialApp(
//                 home: Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: pickFiles,
//                     child: Text('Pick files'),
//                   ),
//                   ElevatedButton(
//                     onPressed: setPitch,
//                     child: Text('Set pitch'),
//                   ),
//                   ElevatedButton(
//                     onPressed: setTempo,
//                     child: Text('Set tempo'),
//                   ),
//                 ],
//               ),
//             )
//                 // fit: BoxFit.cover,
//                 ),
//           )),
//     );
//   }
// }
