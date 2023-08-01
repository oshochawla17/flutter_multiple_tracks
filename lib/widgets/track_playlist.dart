import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/services/models/playlists_file.dart';
import 'package:flutter_multiple_tracks/services/providers/playlist_provider.dart';
import 'package:file_picker/file_picker.dart';

class TrackPlaylistComponent extends StatefulWidget {
  const TrackPlaylistComponent(
      {super.key, required this.playlist, required this.index});
  final int index;
  final TrackPlaylist playlist;

  @override
  State<TrackPlaylistComponent> createState() => _TrackPlaylistComponentState();
}

class _TrackPlaylistComponentState extends State<TrackPlaylistComponent> {
  List<PlaylistFile> files = [];
  @override
  void initState() {
    files = widget.playlist.files;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Playlist ${widget.index + 1}',
        ),
        const SizedBox(width: 10),
        InkWell(
          child: const Icon(
            Icons.playlist_add,
            size: 30,
          ),
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              if (result.files.single.path != null) {
                widget.playlist.addFile(PlaylistFile(
                    name: result.files.single.name,
                    path: result.files.single.path!));
              }
            } else {
              // User canceled the picker
            }
            setState(() {
              files = widget.playlist.files;
            });
          },
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        // use max 15 char for file name
                        widget.playlist.files[index].name.length > 15
                            ? widget.playlist.files[index].name.substring(0, 15)
                            : widget.playlist.files[index].name,
                      ),
                      const SizedBox(width: 10),
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
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}
