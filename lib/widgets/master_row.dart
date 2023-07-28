import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/global_options_provider.dart';

import 'package:flutter_multiple_tracks/widgets/main_settings.dart';
import 'package:flutter_multiple_tracks/widgets/master_play_button.dart';
import 'package:provider/provider.dart';

class MasterRow extends StatelessWidget {
  const MasterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MasterPlayButton(),
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext builderContext) {
                    final globalOptionsProvider =
                        context.read<GlobalOptionsProvider>();
                    return ChangeNotifierProvider<GlobalOptionsProvider>.value(
                      value: globalOptionsProvider,
                      child: const MainSettings(),
                    );
                  },
                );
              },
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Track',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Reset All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
