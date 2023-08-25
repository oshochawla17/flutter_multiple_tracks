// import 'package:flutter/material.dart';
// import 'package:flutter_multiple_tracks/services/models/track_options.dart';
// import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
// import 'package:provider/provider.dart';

// class MainSettings extends StatefulWidget {
//   const MainSettings({super.key});

//   @override
//   State<MainSettings> createState() => _MainSettingsState();
// }

// class _MainSettingsState extends State<MainSettings> {
//   late int pitch;
//   late int tempo;
//   @override
//   void initState() {
//     final globalOptionsProvider = context.read<GlobalOptionsProvider>();
//     pitch = globalOptionsProvider.options.pitch;
//     tempo = globalOptionsProvider.options.tempo;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text('Fine Tune'),
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0),
//             child: Row(
//               children: [
//                 const SizedBox(width: 55, child: Text('Pitch:')),
//                 Container(
//                   width: 60,
//                   padding: const EdgeInsets.only(left: 5),
//                   child: Text(
//                     pitch.toStringAsFixed(2),
//                     textAlign: TextAlign.left,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: pitch.toDouble(),
//                     label: pitch.toString(),
//                     min: TrackOptions.minPitch.toDouble(),
//                     max: TrackOptions.maxPitch.toDouble(),
//                     onChanged: (double value) {
//                       setState(() {
//                         pitch = value.toInt();
//                       });
//                       context.read<GlobalOptionsProvider>().updateOptions(
//                           context
//                               .read<GlobalOptionsProvider>()
//                               .options
//                               .copyWith(pitch: value.toInt()));
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5.0),
//             child: Row(
//               children: [
//                 const SizedBox(width: 55, child: Text('BPM:')),
//                 Container(
//                   width: 60,
//                   padding: const EdgeInsets.only(left: 5),
//                   child: Text(
//                     (tempo).toStringAsFixed(0),
//                     textAlign: TextAlign.left,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: tempo.toDouble(),
//                     label: (tempo).toStringAsFixed(0),
//                     min: TrackOptions.minTempo.toDouble(),
//                     max: TrackOptions.maxTempo.toDouble(),
//                     // divisions: TrackOptions.maxTempo - TrackOptions.minTempo,
//                     onChanged: (double value) {
//                       setState(() {
//                         tempo = value.toInt();
//                       });
//                       context.read<GlobalOptionsProvider>().updateOptions(
//                           context
//                               .read<GlobalOptionsProvider>()
//                               .options
//                               .copyWith(tempo: value.toInt()));
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
