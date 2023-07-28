import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/sound_blend_global_options.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:provider/provider.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({super.key});

  @override
  State<MainSettings> createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  late double pitch;
  late double tempo;
  @override
  void initState() {
    final globalOptionsProvider = context.read<GlobalOptionsProvider>();
    pitch = globalOptionsProvider.options.pitch;
    tempo = globalOptionsProvider.options.tempo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Fine Tune'),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: [
                const SizedBox(width: 55, child: Text('Pitch:')),
                Container(
                  width: 60,
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    pitch.toStringAsFixed(2),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: pitch,
                    label: pitch.toString(),
                    max: 12.00,
                    min: -12.00,
                    onChanged: (double value) {
                      setState(() {
                        pitch = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: [
                const SizedBox(width: 55, child: Text('Tempo:')),
                Container(
                  width: 60,
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    '${(tempo * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: tempo,
                    label: '${(tempo * 100).toStringAsFixed(0)}%',
                    divisions: 3,
                    max: 2,
                    min: 0.5,
                    onChanged: (double value) {
                      setState(() {
                        tempo = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<GlobalOptionsProvider>().updateOptions(
                    SoundBlendGlobalOptions(pitch: pitch, tempo: tempo));
                Navigator.pop(context);
              },
              child: const Text(
                'Apply',
              ),
            ),
          )
        ],
      ),
    );
  }
}
