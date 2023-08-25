import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/instruments_library/instrument_file/instrument_file.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';

class TrackPlaylistComponent extends StatefulWidget {
  const TrackPlaylistComponent(
      {super.key, required this.playlist, required this.index});
  final int index;
  final TrackPlaylist playlist;

  @override
  State<TrackPlaylistComponent> createState() => _TrackPlaylistComponentState();
}

class _TrackPlaylistComponentState extends State<TrackPlaylistComponent> {
  List<InstrumentFile> files = [];
  @override
  void initState() {
    files = widget.playlist.files;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Playlist ${widget.index + 1}',
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 70,
                child: ListView.builder(
                    itemCount: widget.playlist.files.length,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var isSelected = widget.playlist.files[index].isSelected;
                      return Opacity(
                        opacity: isSelected ? 1 : 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Icon(
                                isSelected
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                size: 30,
                              ),
                              onTap: () {
                                if (isSelected) {
                                  widget.playlist.unslectFile(
                                      widget.playlist.files[index]);
                                } else {
                                  widget.playlist
                                      .selectFile(widget.playlist.files[index]);
                                }

                                setState(() {
                                  files = widget.playlist.files;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(widget.playlist.files[index].name),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Playlist ${widget.index + 1}',
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 70,
                child: ListView.builder(
                    itemCount:
                        widget.playlist.player.state.playlist.medias.length,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: const Icon(
                              Icons.remove_circle,
                              size: 30,
                            ),
                            onTap: () {
                              widget.playlist
                                  .removeFile(widget.playlist.files[index]);
                              setState(() {
                                files = widget.playlist.files;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(widget.playlist.files[index].name),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
