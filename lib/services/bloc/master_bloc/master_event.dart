abstract class MasterEvent {
  const MasterEvent();

  bool get stringify => false;
}

class MasterPlayEvent extends MasterEvent {
  MasterPlayEvent() : super();
}

class MasterPauseEvent extends MasterEvent {
  MasterPauseEvent() : super();
}
