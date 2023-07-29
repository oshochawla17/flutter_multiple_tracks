import 'package:equatable/equatable.dart';

abstract class MasterState extends Equatable {
  const MasterState();
}

class MasterInitialState extends MasterState {
  const MasterInitialState() : super();
  @override
  List<Object> get props => [];
}

class PlayPress extends MasterState {
  const PlayPress();
  @override
  List<Object> get props => [];
}

class MasterPlaying extends MasterState {
  const MasterPlaying();

  @override
  List<Object> get props => [];
}

class MasterPaused extends MasterState {
  const MasterPaused();

  @override
  List<Object> get props => [];
}
