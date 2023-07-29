import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:flutter_multiple_tracks/widgets/track_playlist.dart';
import 'package:provider/provider.dart';

class TrackPlaylistsSheet extends StatelessWidget {
  const TrackPlaylistsSheet({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Consumer<TrackPlaylistsStatus>(
          builder: (context, provider, child) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Text(
                'Playlists',
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TrackPlaylistComponent(
                        playlist: provider.playlists[index], index: index);
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
