enum Instruments { tabla, pakhawaj, swarmandal, tanpura1, tanpura2, metronome }

// assets/images/instruments/${provider.instrument.name}.png
extension InstrumentsExt on Instruments {
  String imagePath() {
    switch (this) {
      case Instruments.tabla:
        return 'assets/images/instruments/TABLA.png';
      case Instruments.pakhawaj:
        return 'assets/images/instruments/PAKHAWAJ.png';
      case Instruments.swarmandal:
        return 'assets/images/instruments/SWARMANDAL.png';
      case Instruments.tanpura1:
        return 'assets/images/instruments/TANPURA.png';
      case Instruments.tanpura2:
        return 'assets/images/instruments/TANPURA.png';
      case Instruments.metronome:
        return 'assets/images/instruments/METRONOME.png';
    }
  }

  String instrumentName() {
    switch (this) {
      case Instruments.tabla:
        return 'Tabla';
      case Instruments.pakhawaj:
        return 'Pakhawaj';
      case Instruments.swarmandal:
        return 'Swarmandal';
      case Instruments.tanpura1:
        return 'Tanpura 1';
      case Instruments.tanpura2:
        return 'Tanpura 2';
      case Instruments.metronome:
        return 'Metronome';
    }
  }
}
