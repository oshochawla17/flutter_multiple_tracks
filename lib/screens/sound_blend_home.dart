import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';
import 'package:flutter_multiple_tracks/widgets/master_row.dart';
import 'package:provider/provider.dart';

class SoundBlendHome extends StatelessWidget {
  const SoundBlendHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Sound Blend'),
        title: Container(),
      ),
      body: ChangeNotifierProvider(
        create: (context) => GlobalOptionsProvider(),
        child: Column(
          children: const [
            Text(
              'Sound Blend',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: MasterRow(),
            )
          ],
        ),
      ),
    );
  }
}
