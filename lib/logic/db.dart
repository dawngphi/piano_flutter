import 'chord.dart';
import 'key.dart';
import 'note.dart';

class ChordTableEntry {
  final List<String> aliases;
  final String? name;
  final String quality;
  final List<int> intervals;

  const ChordTableEntry({
    required this.aliases,
    required this.name,
    required this.quality,
    required this.intervals,
  });
}

const List<ChordTableEntry> chordTable = [
  ChordTableEntry(aliases: ["", "M"], name: "major", quality: "Major", intervals: [0, 4, 3]),
  ChordTableEntry(aliases: ["", "M"], name: "major", quality: "Major", intervals: [0, 4, 3]),
  ChordTableEntry(aliases: ["m", "min", "-"], name: "minor", quality: "Minor", intervals: [0, 3, 4]),
  ChordTableEntry(aliases: ["maj7", "Δ", "ma7", "M7", "Maj7"], name: "major seventh", quality: "Major", intervals: [0, 4, 3, 4]),
  ChordTableEntry(aliases: ["7", "dom"], name: "dominant seventh", quality: "Major", intervals: [0, 4, 3, 3]),
  ChordTableEntry(aliases: ["m7", "min7", "mi7", "-7"], name: "minor seventh", quality: "Minor", intervals: [0, 3, 4, 3]),
  ChordTableEntry(aliases: ["dim", "°", "o"], name: "diminished", quality: "Diminished", intervals: [0, 3, 3]),
  ChordTableEntry(aliases: ["m7♭5", "h7", "_7♭5"], name: "half diminished seventh", quality: "Diminished", intervals: [0, 3, 3, 4]),
  ChordTableEntry(aliases: ["dim7", "°7", "o7"], name: "diminished seventh", quality: "Diminished", intervals: [0, 3, 3, 3]),
  ChordTableEntry(aliases: ["aug", "+", "+5"], name: "augmented", quality: "Augmented", intervals: [0, 4, 4]),
  ChordTableEntry(aliases: ["sus2"], name: "suspended 2nd", quality: "", intervals: [0, 2, 5]),
  ChordTableEntry(aliases: ["sus4"], name: "suspended 4th", quality: "", intervals: [0, 5, 2]),
  ChordTableEntry(aliases: ["maj9", "Δ9"], name: "major ninth", quality: "Major", intervals: [0, 4, 3, 4, 3]),
  ChordTableEntry(aliases: ["maj11", "Δ11"], name: "major eleventh", quality: "Major", intervals: [0, 4, 3, 4, 3, 3]),
  ChordTableEntry(aliases: ["maj13", "Δ13"], name: "major thirteenth", quality: "Major", intervals: [0, 4, 3, 4, 3, 7]),
  ChordTableEntry(aliases: ["6", "add6", "add13", "M6"], name: "major sixth", quality: "Major", intervals: [0, 4, 3, 2]),
  ChordTableEntry(aliases: ["6/9", "69"], name: "sixth/ninth", quality: "Major", intervals: [0, 4, 3, 2, 5]),
  ChordTableEntry(aliases: ["maj♯4", "Δ♯4", "Δ♯11"], name: "lydian", quality: "Major", intervals: [0, 4, 3, 4, 7]),
  ChordTableEntry(aliases: ["M7♭6"], name: "major seventh ♭6", quality: "Major", intervals: [0, 4, 4, 3]),
  ChordTableEntry(aliases: ["mM7", "m/ma7", "m/maj7", "m/M7", "-Δ7", "mΔ"], name: "minor/major seventh", quality: "Minor", intervals: [0, 3, 4, 4]),
  ChordTableEntry(aliases: ["m6"], name: "minor sixth", quality: "Minor", intervals: [0, 3, 4, 2]),
  ChordTableEntry(aliases: ["m9"], name: "minor ninth", quality: "Minor", intervals: [0, 3, 4, 3, 4]),
  ChordTableEntry(aliases: ["m11"], name: "minor eleventh", quality: "Minor", intervals: [0, 3, 4, 3, 4, 3]),
  ChordTableEntry(aliases: ["m13"], name: "minor thirteenth", quality: "Minor", intervals: [0, 3, 4, 3, 4, 7]),
  ChordTableEntry(aliases: ["9"], name: "dominant ninth", quality: "Major", intervals: [0, 4, 3, 3, 4]),
  ChordTableEntry(aliases: ["11"], name: "dominant eleventh", quality: "", intervals: [0, 7, 3, 4, 3]),
  ChordTableEntry(aliases: ["13"], name: "dominant thirteenth", quality: "Major", intervals: [0, 4, 3, 3, 4, 7]),
  ChordTableEntry(aliases: ["7♯11", "7♯4"], name: "lydian dominant seventh", quality: "Major", intervals: [0, 4, 3, 3, 8]),
  ChordTableEntry(aliases: ["7♭9"], name: "dominant ♭9", quality: "Major", intervals: [0, 4, 3, 3, 3]),
  ChordTableEntry(aliases: ["7♯9"], name: "dominant ♯9", quality: "Major", intervals: [0, 4, 3, 3, 5]),
  ChordTableEntry(aliases: ["alt7"], name: "altered", quality: "Major", intervals: [0, 4, 6, 3]),
  ChordTableEntry(aliases: ["7sus4"], name: "suspended 4th seventh", quality: "", intervals: [0, 5, 2, 3]),
  ChordTableEntry(aliases: ["♭9sus", "phryg"], name: "suspended 4th ♭9", quality: "", intervals: [0, 5, 2, 3, 3]),
  ChordTableEntry(aliases: ["5"], name: "fifth", quality: "", intervals: [0, 7]),
  ChordTableEntry(aliases: ["maj7♯5", "maj7+5"], name: "augmented seventh", quality: "Augmented", intervals: [0, 4, 4, 3]),
  ChordTableEntry(aliases: ["maj9♯11", "Δ9♯11"], name: "major ♯11 (lydian)", quality: "Major", intervals: [0, 4, 3, 4, 3, 4]),
  ChordTableEntry(aliases: ["sus24", "sus4add9"], name: null, quality: "", intervals: [0, 2, 3, 2]),
  ChordTableEntry(aliases: ["M♭6"], name: null, quality: "Major", intervals: [0, 4, 4]),
  ChordTableEntry(aliases: ["maj9♯5", "Maj9♯5"], name: null, quality: "Augmented", intervals: [0, 4, 4, 3, 3]),
  ChordTableEntry(aliases: ["7♯5", "+7", "7aug", "aug7"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2]),
  ChordTableEntry(aliases: ["7♯5♯9", "7alt", "7♯5♯9_", "7♯9♭13_"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2, 5]),
  ChordTableEntry(aliases: ["9♯5", "9+"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2, 4]),
  ChordTableEntry(aliases: ["9♯5♯11"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2, 4, 4]),
  ChordTableEntry(aliases: ["7♯5♭9"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2, 3]),
  ChordTableEntry(aliases: ["7♯5♭9♯11"], name: null, quality: "Augmented", intervals: [0, 4, 4, 2, 3, 5]),
  ChordTableEntry(aliases: ["+add♯9"], name: null, quality: "Augmented", intervals: [0, 4, 4, 7]),
  ChordTableEntry(aliases: ["M♯5add9", "+add9"], name: null, quality: "Augmented", intervals: [0, 4, 4, 6]),
  ChordTableEntry(aliases: ["M6♯11", "M6♭5", "6♯11", "6♭5"], name: null, quality: "Major", intervals: [0, 4, 3, 2, 9]),
  ChordTableEntry(aliases: ["M7add13"], name: null, quality: "Major", intervals: [0, 4, 3, 2, 2, 3]),
  ChordTableEntry(aliases: ["69♯11"], name: null, quality: "Major", intervals: [0, 4, 3, 2, 5, 4]),
  ChordTableEntry(aliases: ["7♭6"], name: null, quality: "Major", intervals: [0, 4, 3, 1, 2]),
  ChordTableEntry(aliases: ["maj7♯9♯11"], name: null, quality: "Major", intervals: [0, 4, 3, 4, 4, 3]),
  ChordTableEntry(aliases: ["M13♯11", "maj13♯11", "M13+4", "M13♯4"], name: null, quality: "Major", intervals: [0, 4, 3, 4, 3, 4, 3]),
  ChordTableEntry(aliases: ["M7♭9"], name: null, quality: "Major", intervals: [0, 4, 3, 4, 2]),
  ChordTableEntry(aliases: ["7♯11♭13", "7♭5♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 8, 2]),
  ChordTableEntry(aliases: ["7♯9♯11", "7♭5♯9"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 5, 3]),
  ChordTableEntry(aliases: ["13♯9♯11"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 5, 3, 3]),
  ChordTableEntry(aliases: ["7♯9♯11♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 5, 3, 2]),
  ChordTableEntry(aliases: ["13♯9", "13♯9_"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 5, 6]),
  ChordTableEntry(aliases: ["7♯9♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 5, 5]),
  ChordTableEntry(aliases: ["9♯11", "9+4", "9♯4", "9♯11_", "9♯4_"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 4, 4]),
  ChordTableEntry(aliases: ["13♯11", "13+4", "13♯4"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 4, 4, 3]),
  ChordTableEntry(aliases: ["9♯11♭13", "9♭5♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 4, 4, 2]),
  ChordTableEntry(aliases: ["7♭9♯11", "7♭5♭9"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 5]),
  ChordTableEntry(aliases: ["13♭9♯11"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 5, 3]),
  ChordTableEntry(aliases: ["7♭9♭13♯11", "7♭9♯11♭13", "7♭5♭9♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 5, 2]),
  ChordTableEntry(aliases: ["13♭9"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 8]),
  ChordTableEntry(aliases: ["7♭9♭13"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 7]),
  ChordTableEntry(aliases: ["7♭9♯9"], name: null, quality: "Major", intervals: [0, 4, 3, 3, 3, 2]),
  ChordTableEntry(aliases: ["Madd9", "2", "add9", "add2"], name: null, quality: "Major", intervals: [0, 4, 3, 7]),
  ChordTableEntry(aliases: ["Madd♭9"], name: null, quality: "Major", intervals: [0, 4, 3, 6]),
  ChordTableEntry(aliases: ["M♭5"], name: null, quality: "Major", intervals: [0, 4, 2]),
  ChordTableEntry(aliases: ["13♭5"], name: null, quality: "Major", intervals: [0, 4, 2, 3, 1, 4]),
  ChordTableEntry(aliases: ["M7♭5"], name: null, quality: "Major", intervals: [0, 4, 2, 5]),
  ChordTableEntry(aliases: ["M9♭5"], name: null, quality: "Major", intervals: [0, 4, 2, 5, 3]),
  ChordTableEntry(aliases: ["7♭5"], name: null, quality: "Major", intervals: [0, 4, 2, 4]),
  ChordTableEntry(aliases: ["9♭5"], name: null, quality: "Major", intervals: [0, 4, 2, 4, 4]),
  ChordTableEntry(aliases: ["7no5"], name: null, quality: "Major", intervals: [0, 4, 6]),
  ChordTableEntry(aliases: ["7♭13"], name: null, quality: "Major", intervals: [0, 4, 6, 10]),
  ChordTableEntry(aliases: ["9no5"], name: null, quality: "Major", intervals: [0, 4, 6, 4]),
  ChordTableEntry(aliases: ["13no5"], name: null, quality: "Major", intervals: [0, 4, 6, 4, 7]),
  ChordTableEntry(aliases: ["9♭13"], name: null, quality: "Major", intervals: [0, 4, 6, 4, 6]),
  ChordTableEntry(aliases: ["madd4"], name: null, quality: "Minor", intervals: [0, 3, 2, 2]),
  ChordTableEntry(aliases: ["m♯5", "m+", "m♭6"], name: null, quality: "Augmented", intervals: [0, 3, 5]),
  ChordTableEntry(aliases: ["m69", "_69"], name: null, quality: "Minor", intervals: [0, 3, 4, 2, 5]),
  ChordTableEntry(aliases: ["mMaj7♭6"], name: null, quality: "Minor", intervals: [0, 3, 4, 1, 3]),
  ChordTableEntry(aliases: ["mMaj9♭6"], name: null, quality: "Minor", intervals: [0, 3, 4, 1, 3, 3]),
  ChordTableEntry(aliases: ["mMaj9", "-Maj9"], name: null, quality: "Minor", intervals: [0, 3, 4, 4, 3]),
  ChordTableEntry(aliases: ["m7add11", "m7add4"], name: null, quality: "Minor", intervals: [0, 3, 4, 3, 7]),
  ChordTableEntry(aliases: ["madd9"], name: null, quality: "Minor", intervals: [0, 3, 4, 7]),
  ChordTableEntry(aliases: ["o7M7"], name: null, quality: "Diminished", intervals: [0, 3, 3, 3, 2]),
  ChordTableEntry(aliases: ["oM7"], name: null, quality: "Diminished", intervals: [0, 3, 3, 5]),
  ChordTableEntry(aliases: ["m♭6M7"], name: null, quality: "Minor", intervals: [0, 3, 5, 3]),
  ChordTableEntry(aliases: ["m7♯5"], name: null, quality: "Minor", intervals: [0, 3, 5, 2]),
  ChordTableEntry(aliases: ["m9♯5"], name: null, quality: "Minor", intervals: [0, 3, 5, 2, 4]),
  ChordTableEntry(aliases: ["m11♯5"], name: null, quality: "Minor", intervals: [0, 3, 5, 2, 4, 3]),
  ChordTableEntry(aliases: ["m9♭5", "h9", "-9♭5"], name: null, quality: "Minor", intervals: [0, 3, 3, 4, 4]),
  ChordTableEntry(aliases: ["m11♭5", "h11", "_11♭5"], name: null, quality: "Minor", intervals: [0, 3, 3, 4, 4, 3]),
  ChordTableEntry(aliases: ["m♭6♭9"], name: null, quality: "Minor", intervals: [0, 3, 5, 5]),
  ChordTableEntry(aliases: ["M7♯5sus4"], name: null, quality: "Augmented", intervals: [0, 5, 3, 3]),
  ChordTableEntry(aliases: ["M9♯5sus4"], name: null, quality: "Augmented", intervals: [0, 5, 3, 3, 3]),
  ChordTableEntry(aliases: ["7♯5sus4"], name: null, quality: "Augmented", intervals: [0, 5, 3, 2]),
  ChordTableEntry(aliases: ["M7sus4"], name: null, quality: "", intervals: [0, 5, 2, 4]),
  ChordTableEntry(aliases: ["M9sus4"], name: null, quality: "", intervals: [0, 5, 2, 4, 3]),
  ChordTableEntry(aliases: ["9sus4", "9sus"], name: null, quality: "", intervals: [0, 5, 2, 3, 4]),
  ChordTableEntry(aliases: ["13sus4", "13sus"], name: null, quality: "", intervals: [0, 5, 2, 3, 4, 7]),
  ChordTableEntry(aliases: ["7sus4♭9♭13", "7♭9♭13sus4"], name: null, quality: "", intervals: [0, 5, 2, 3, 3, 7]),
  ChordTableEntry(aliases: ["4", "quartal"], name: null, quality: "", intervals: [0, 5, 5, 5]),
  ChordTableEntry(aliases: ["11♭9"], name: null, quality: "", intervals: [0, 7, 3, 3, 4]),
];

int locateChordIndex(String name) {
  for (int i = 0; i < chordTable.length; i++) {
    if (chordTable[i].name == name) {
      return i;
    }
  }
  throw Exception('Chord with name "$name" not found');
}

class ChordIndex {
  static final int maj = locateChordIndex("major");
  static final int min = locateChordIndex("minor");
  static final int dim = locateChordIndex("diminished");
  static final int aug = locateChordIndex("augmented");
  static final int maj7 = locateChordIndex("major seventh");
  static final int maj9 = locateChordIndex("major ninth");
  static final int maj11 = locateChordIndex("major eleventh");
  static final int maj13 = locateChordIndex("major thirteenth");
  static final int sixth = locateChordIndex("major sixth");
  static final int seventh = locateChordIndex("dominant seventh");
  static final int ninth = locateChordIndex("dominant ninth");
  static final int eleventh = locateChordIndex("dominant eleventh");
  static final int thirteenth = locateChordIndex("dominant thirteenth");
  static final int sus4 = locateChordIndex("suspended 4th");
  static final int m6 = locateChordIndex("minor sixth");
  static final int m7 = locateChordIndex("minor seventh");
  static final int m9 = locateChordIndex("minor ninth");
  static final int m11 = locateChordIndex("minor eleventh");
  static final int m7b5 = locateChordIndex("half diminished seventh");
}

class ChurchMode {
  static const List<int> intervals = [2, 2, 1, 2, 2, 2, 1];
  static const List<String> names = [
    "Ionian", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Aeolian", "Locrian"
  ];
  static final List<List<int>> chordProgression = [
    [ChordIndex.maj, ChordIndex.maj7, ChordIndex.maj9, ChordIndex.maj11, ChordIndex.maj13, ChordIndex.sixth],
    [ChordIndex.min, ChordIndex.m7, ChordIndex.m9, ChordIndex.m11, ChordIndex.m6],
    [ChordIndex.min, ChordIndex.m7],
    [ChordIndex.maj, ChordIndex.maj7, ChordIndex.maj9, ChordIndex.maj13, ChordIndex.sixth],
    [ChordIndex.maj, ChordIndex.seventh, ChordIndex.ninth, ChordIndex.eleventh, ChordIndex.sus4, ChordIndex.thirteenth],
    [ChordIndex.min, ChordIndex.m7, ChordIndex.m9, ChordIndex.m11],
    [ChordIndex.dim, ChordIndex.m7b5],
  ];
}

class Mode {
  final String name;
  final List<List<int>> chordIndex;
  final List<String> rome;
  final List<int> intervals;

  const Mode({
    required this.name,
    required this.chordIndex,
    required this.rome,
    required this.intervals,
  });
}

const List<String> romeNumerals = ['i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii'];

List<Mode> _generateModesTable() {
  List<Mode> modesTable = [];

  // Fill in church modes
  for (int i = 0; i < ChurchMode.names.length; i++) {
    final chordProgression = [
      ...ChurchMode.chordProgression.sublist(i),
      ...ChurchMode.chordProgression.sublist(0, i)
    ];

    final rome = chordProgression.asMap().entries.map((entry) {
      int index = entry.key;
      List<int> chords = entry.value;
      String romeNumeral = romeNumerals[index];

      if (chords[0] == ChordIndex.maj) {
        romeNumeral = romeNumeral.toUpperCase();
      }
      if (chords[0] == ChordIndex.dim) {
        romeNumeral = romeNumeral + '°';
      }
      if (chords[0] == ChordIndex.aug) {
        romeNumeral = romeNumeral.toUpperCase() + '+';
      }
      return romeNumeral;
    }).toList();

    final intervals = [
      ...ChurchMode.intervals.sublist(i),
      ...ChurchMode.intervals.sublist(0, i)
    ];

    modesTable.add(Mode(
      name: ChurchMode.names[i],
      chordIndex: chordProgression,
      rome: rome,
      intervals: intervals,
    ));
  }

  // Fill in Major and Minor modes
  modesTable = [
    Mode(name: "Major", chordIndex: modesTable[0].chordIndex, rome: modesTable[0].rome, intervals: modesTable[0].intervals),
    Mode(name: "Minor", chordIndex: modesTable[5].chordIndex, rome: modesTable[5].rome, intervals: modesTable[5].intervals),
    ...modesTable
  ];

  // Fill in "Melodic Minor" and "Harmonic Minor" modes
  modesTable = [
    ...modesTable,
    Mode(
      name: "Melodic Minor",
      chordIndex: [
        [ChordIndex.min],  [ChordIndex.min],  [ChordIndex.aug],  [ChordIndex.maj],
         [ChordIndex.maj],  [ChordIndex.dim],  [ChordIndex.dim]
      ],
      rome: const ['i', 'ii', 'III+', 'IV', 'V', 'vi°', 'vii°'],
      intervals: const [2, 1, 2, 2, 2, 2, 1],
    ),
    Mode(
      name: "Harmonic Minor",
      chordIndex: [
        [ChordIndex.min], [ChordIndex.dim], [ChordIndex.aug], [ChordIndex.min],
        [ChordIndex.maj], [ChordIndex.maj], [ChordIndex.dim]
      ],
      rome: const ['i', 'ii°', 'III+', 'iv', 'V', 'VI', 'vii°'],
      intervals: const [2, 1, 2, 2, 1, 3, 1],
    )
  ];

  return modesTable;
}

final List<Mode> modesTable = _generateModesTable();

class Interval {
  final String abbrev;
  final String name;

  const Interval({required this.abbrev, required this.name});
}

const Map<int, Interval> intervalTable = {
  0: Interval(abbrev: 'P1', name: 'Root'),
  1: Interval(abbrev: 'm2', name: 'Minor Second'),
  2: Interval(abbrev: 'M2', name: 'Major Second'),
  3: Interval(abbrev: 'm3', name: 'Minor Third'),
  4: Interval(abbrev: 'M3', name: 'Major Third'),
  5: Interval(abbrev: 'P4', name: 'Perfect Fourth'),
  6: Interval(abbrev: 'TT', name: 'Tritone'),
  7: Interval(abbrev: 'P5', name: 'Perfect Fifth'),
  8: Interval(abbrev: 'm6', name: 'Minor Sixth'),
  9: Interval(abbrev: 'M6', name: 'Major Sixth'),
  10: Interval(abbrev: 'm7', name: 'Minor Seventh'),
  11: Interval(abbrev: 'M7', name: 'Major Seventh'),
  12: Interval(abbrev: 'P8', name: 'Perfect Octave'),
};

const List<String> inversionNames = [
  'Root Position',
  '1st Inversion',
  '2nd Inversion',
  '3rd Inversion',
];

List<Note> _generateNotes() {
  List<Note> notes = [];
  for (Octave oct in Octave.values) {
    for (KeyName k in chromaticName) {
      notes.add(Note( k,  oct));
    }
  }
  return notes;
}
final List<Note> allNotes = _generateNotes();
final List<Note> notes = _generateNotes();

Map<String, List<Chord>> _generateChords() {
  Map<String, List<Chord>> chords = {};

  for (KeyName k in keySimpleList) {
    chords[k.name] = [];
    for (ChordTableEntry row in chordTable) {
      Chord chord = Chord(key: keys[k]!, intervals: List.from(row.intervals));
      chord.tonic = k.name;
      String name = row.name != null ? '${k.name} ${row.name}' : '';
      List<String> alias = row.aliases.map((str) => '${k.name}$str').toList();
      chord.alias = alias;
      chord.fullName = name;
      chord.quality = row.quality;
      chord.calcInversions();
      chords[k.name]!.add(chord);
    }
  }

  return chords;
}

final Map<String, List<Chord>> chords = _generateChords();

List<Chord> _generateAllChords() {
  List<Chord> allChords = [];
  List<Chord> allInversions = [];

  for (String key in chords.keys) {
    for (Chord c in chords[key]!) {
      allChords.add(c);
    }
  }

  for (Chord c in allChords) {
    allInversions.addAll(c.inversions);
  }

  return [...allChords, ...allInversions];
}

final List<Chord> allChords = _generateAllChords();