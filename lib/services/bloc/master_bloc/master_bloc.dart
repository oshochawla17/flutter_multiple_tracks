import 'package:bloc/bloc.dart';

import 'master.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc() : super(const MasterInitialState());

  @override
  Stream<MasterState> mapEventToState(
    MasterEvent event,
  ) async* {
    if (event is MasterPlayEvent) {
      yield const PlayPress();
    } else if (event is MasterPauseEvent) {}
  }

  @override
  void onEvent(MasterEvent event) {
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<MasterEvent, MasterState> transition) {
    super.onTransition(transition);
  }
}
