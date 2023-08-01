import 'package:equatable/equatable.dart';

class PlaylistFile extends Equatable {
  final String path;
  final String name;

  const PlaylistFile({
    required this.path,
    required this.name,
  });
  PlaylistFile copyWith({
    String? path,
    String? name,
  }) {
    return PlaylistFile(
      path: path ?? this.path,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [path, name];
}
