enum KeyName {
  c('C'),
  cSharp('C♯'),
  dFlat('D♭'),
  d('D'),
  dSharp('D♯'),
  eFlat('E♭'),
  e('E'),
  f('F'),
  fSharp('F♯'),
  gFlat('G♭'),
  g('G'),
  gSharp('G♯'),
  aFlat('A♭'),
  a('A'),
  aSharp('A♯'),
  bFlat('B♭'),
  b('B');

  const KeyName(this.name);
  final String name;

  @override
  String toString() => name;
}

KeyName? parseKeyName(String input) {
  // 1. Thử tìm theo tên trong enum (Unicode như "C♯")
  try {
    return KeyName.values.firstWhere((keyName) => keyName.name == input);
  } catch (_) {
    // 2. Nếu không tìm được, fallback về string cơ bản (chẳng hạn URL input)
    switch (input) {
      case 'C': return KeyName.c;
      case 'C#': return KeyName.cSharp;
      case 'Db': return KeyName.dFlat;
      case 'D': return KeyName.d;
      case 'D#': return KeyName.dSharp;
      case 'Eb': return KeyName.eFlat;
      case 'E': return KeyName.e;
      case 'F': return KeyName.f;
      case 'F#': return KeyName.fSharp;
      case 'Gb': return KeyName.gFlat;
      case 'G': return KeyName.g;
      case 'G#': return KeyName.gSharp;
      case 'Ab': return KeyName.aFlat;
      case 'A': return KeyName.a;
      case 'A#': return KeyName.aSharp;
      case 'Bb': return KeyName.bFlat;
      case 'B': return KeyName.b;
      default: return null;
    }
  }
}


const Map<KeyName, int> keys = {
  KeyName.c: 0,
  KeyName.cSharp: 1,
  KeyName.dFlat: 1,
  KeyName.d: 2,
  KeyName.dSharp: 3,
  KeyName.eFlat: 3,
  KeyName.e: 4,
  KeyName.f: 5,
  KeyName.fSharp: 6,
  KeyName.gFlat: 6,
  KeyName.g: 7,
  KeyName.gSharp: 8,
  KeyName.aFlat: 8,
  KeyName.a: 9,
  KeyName.aSharp: 10,
  KeyName.bFlat: 10,
  KeyName.b: 11,
};

enum BlackWhite {
  white(0),
  black(1);

  const BlackWhite(this.value);
  final int value;
}

const List<BlackWhite> bwMap = [
  BlackWhite.white,
  BlackWhite.black,
  BlackWhite.white,
  BlackWhite.black,
  BlackWhite.white,
  BlackWhite.white,
  BlackWhite.black,
  BlackWhite.white,
  BlackWhite.black,
  BlackWhite.white,
  BlackWhite.black,
  BlackWhite.white,
];

const List<KeyName> keySimpleList = [
  KeyName.c,
  KeyName.cSharp,
  KeyName.dFlat,
  KeyName.d,
  KeyName.dSharp,
  KeyName.eFlat,
  KeyName.e,
  KeyName.f,
  KeyName.fSharp,
  KeyName.gFlat,
  KeyName.g,
  KeyName.gSharp,
  KeyName.aFlat,
  KeyName.a,
  KeyName.aSharp,
  KeyName.bFlat,
  KeyName.b,
];

const List<KeyName> chromaticName = [
  KeyName.c,
  KeyName.dFlat,
  KeyName.d,
  KeyName.eFlat,
  KeyName.e,
  KeyName.f,
  KeyName.fSharp,
  KeyName.g,
  KeyName.aFlat,
  KeyName.a,
  KeyName.bFlat,
  KeyName.b,
];

const List<List<KeyName>> keyPossibleName = [
  [KeyName.c],
  [KeyName.cSharp, KeyName.dFlat],
  [KeyName.d],
  [KeyName.dSharp, KeyName.eFlat],
  [KeyName.e],
  [KeyName.f],
  [KeyName.fSharp, KeyName.gFlat],
  [KeyName.g],
  [KeyName.gSharp, KeyName.aFlat],
  [KeyName.a],
  [KeyName.aSharp, KeyName.bFlat],
  [KeyName.b],
];

const int octaveKeyCount = 12;

enum Octave {
  two(2),
  three(3),
  four(4),
  five(5),
  six(6);

  const Octave(this.value);
  final int value;
}