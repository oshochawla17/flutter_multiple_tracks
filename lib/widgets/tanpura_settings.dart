import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/widgets/tanpura_sllider.dart';

class TanpuraSettings extends StatelessWidget {
  const TanpuraSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: [
                      SizedBox(width: 55, child: Text('BPM:')),
                      TanpuraSlider()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
