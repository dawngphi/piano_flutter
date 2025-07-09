import 'dart:math' as math;
import 'chord.dart';
import 'key.dart';
// import 'db.dart'; // Assuming db.dart exists with allChords and chords

class HighlightResult {
  final List<bool> highlightTable;
  final bool truncated;

  const HighlightResult({
    required this.highlightTable,
    required this.truncated,
  });
}

List<bool> getHighlightTable(Chord chord) {
  const maxLength = 12 * 3;
  List<bool> highlightTable = List.filled(maxLength, false);
  int startIndex = chord.key;
  highlightTable[startIndex] = true;

  chord.intervals.fold(startIndex, (previousValue, currentValue) {
    int accumulate = previousValue + currentValue;
    if (accumulate < maxLength) {
      highlightTable[accumulate] = true;
    } else {
      print("chord cannot fit in 3 octaves: $chord");
    }
    return accumulate;
  });

  // Remove the last octave if empty
  if (highlightTable.sublist(24).every((v) => !v)) {
    return highlightTable.sublist(0, 24);
  }
  return highlightTable;
}

List<bool> chordAlignMid(List<bool> highlightTable) {
  // If all the notes are in first 2/3 of the keyboard (3 octaves)
  if (highlightTable.length > 24 && highlightTable.sublist(24).every((h) => h == false)) {
    // Move notes to the middle octave
    return [...List.filled(12, false), ...highlightTable.sublist(0, 24)];
  } else {
    // Otherwise, do not move notes. Notes will use octave 4 as base
    return highlightTable;
  }
}

Chord? findChordByName(String key, String chordName) {
  // This would need the chords map from db.dart
  // return chords[key]?.firstWhere(
  //   (c) => c.name == chordName,
  //   orElse: () => null,
  // );
  throw UnimplementedError('Requires chords map from db.dart');
}

String? urlDecodeKey(String? key) {
  if (key != null) {
    return key.replaceAll('-flat', '♭').replaceAll('-sharp', '♯');
  }
  return null;
}

String urlEncodeKey(String key) {
  return key.replaceAll('♯', '-sharp').replaceAll('♭', '-flat');
}

String urlEncodeChord(String chordName) {
  return chordName
      .replaceAll('♯', 'sharp')
      .replaceAll('♭', 'b')
      .replaceAll('/', '_')
      .replaceAll(' ', '-');
}

String? urlDecodeChord(String? chordName) {
  if (chordName != null) {
    return chordName
        .replaceAll('sharp', '♯')
        .replaceAll('b', '♭')
        .replaceAll('_', '/')
        .replaceAll('-', ' ');
  }
  return null;
}

bool Function(Chord) chordFilterByKeyword(String kw) {
  return (Chord chord) {
    String normalizedKw = kw.toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('♯', '#')
        .replaceAll('♭', 'b');

    List<String> allNames = chord.possibleNames.map((str) =>
        str.toLowerCase()
            .replaceAll(' ', '')
            .replaceAll('♯', '#')
            .replaceAll('♭', 'b')
    ).toList();

    return allNames.any((name) => name.contains(normalizedKw));
  };
}

class ChordScore {
  final Chord chord;
  final double score;

  const ChordScore({
    required this.chord,
    required this.score,
  });
}

List<Chord> searchForChord(String kw) {
  String normalizedKw = kw.toLowerCase()
      .replaceAll(' ', '')
      .replaceAll('♯', '#')
      .replaceAll('♭', 'b');

  if (normalizedKw.isEmpty) return [];

  // This would need the allChords list from db.dart
  // List<ChordScore> chordsWithScores = allChords.map((chord) {
  //   double score = 0;
  //   List<String> allNames = chord.possibleNames.map((str) =>
  //       str.toLowerCase()
  //           .replaceAll(' ', '')
  //           .replaceAll('♯', '#')
  //           .replaceAll('♭', 'b')
  //   ).toList();
  //
  //   for (String name in allNames) {
  //     if (name == normalizedKw) {
  //       score += 1;
  //     } else if (name.contains(normalizedKw)) {
  //       score += 0.1;
  //     }
  //   }
  //   score /= allNames.length;
  //   return ChordScore(chord: chord, score: score);
  // }).toList();
  //
  // chordsWithScores.sort((a, b) => b.score.compareTo(a.score));
  // return chordsWithScores
  //     .where((cs) => cs.score > 0)
  //     .take(20)
  //     .map((cs) => cs.chord)
  //     .toList();

  throw UnimplementedError('Requires allChords list from db.dart');
}

class InferChordResult {
  final dynamic chord; // Can be Chord or String
  final String chordDisplay;

  const InferChordResult({
    required this.chord,
    required this.chordDisplay,
  });
}

InferChordResult inferChord(String kw) {
  String convertToLowerCaseExceptM(String str) {
    return str.split('').map((char) {
      return char != 'M' ? char.toLowerCase() : char;
    }).join('');
  }

  String originalKw = kw;
  String normalizedKw = kw.trim()
      .replaceAll(' ', '')
      .replaceAll('♯', '#')
      .replaceAll('♭', 'b');
  String kwM = convertToLowerCaseExceptM(normalizedKw);
  String kwm = normalizedKw.toLowerCase();

  if (normalizedKw.isEmpty) {
    return const InferChordResult(chord: null, chordDisplay: "");
  }

  // This would need the allChords list from db.dart
  // Search for result without lowercase M to m
  // for (Chord chord in allChords) {
  //   List<String> allNames = chord.possibleNames.map((str) =>
  //       convertToLowerCaseExceptM(str)
  //           .replaceAll(' ', '')
  //           .replaceAll('♯', '#')
  //           .replaceAll('♭', 'b')
  //   ).toList();
  //
  //   for (int i = 0; i < allNames.length; i++) {
  //     if (allNames[i] == kwM) {
  //       return InferChordResult(
  //         chord: chord,
  //         chordDisplay: chord.possibleNames[i],
  //       );
  //     }
  //   }
  // }
  //
  // // If cannot find a match, lowercase M to m
  // for (Chord chord in allChords) {
  //   List<String> allNames = chord.possibleNames.map((str) =>
  //       str.toLowerCase()
  //           .replaceAll(' ', '')
  //           .replaceAll('♯', '#')
  //           .replaceAll('♭', 'b')
  //   ).toList();
  //
  //   for (int i = 0; i < allNames.length; i++) {
  //     if (allNames[i] == kwm) {
  //       return InferChordResult(
  //         chord: chord,
  //         chordDisplay: chord.possibleNames[i],
  //       );
  //     }
  //   }
  // }

  return InferChordResult(
    chord: originalKw,
    chordDisplay: originalKw,
  );
}

Future<void> delay(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}

int sum(List<int> arr) {
  return arr.fold(0, (a, b) => a + b);
}

List<double> randomList(int n, double a, double b) {
  final random = math.Random();
  return List.generate(n, (index) => random.nextDouble() * (b - a) + a);
}

class Descriptives {
  final double mean;
  final double sd;
  final List<double> range;

  const Descriptives({
    required this.mean,
    required this.sd,
    required this.range,
  });
}

Descriptives descriptives(List<double> list) {
  if (list.isEmpty) {
    return const Descriptives(mean: 0, sd: 0, range: [0, 0]);
  }

  double sum = list.fold(0.0, (a, b) => a + b);
  double mean = sum / list.length;

  double min = list.reduce(math.min);
  double max = list.reduce(math.max);

  double variance = list.fold(0.0, (sum, value) => sum + math.pow(value - mean, 2));
  double sd = math.sqrt(variance / (list.length - 1));

  return Descriptives(
    mean: mean,
    sd: sd,
    range: [min, max],
  );
}

List<double> forceDescriptives(List<double> list, double targetMean, double targetSd) {
  if (list.isEmpty) return [];

  final oldDescriptives = descriptives(list);
  final oldMean = oldDescriptives.mean;
  final oldSD = oldDescriptives.sd;

  if (oldSD == 0) return List.filled(list.length, targetMean);

  return list.map((value) =>
  targetSd * (value - oldMean) / oldSD + targetMean
  ).toList();
}

String sanitize(String str) {
  // In Flutter, you might want to use a package like 'sanitize_html'
  // For now, this is a basic implementation
  return str
      .replaceAll(RegExp(r'(\r\n|\n|\r)'), '')
      .replaceAll(RegExp(r'<.*?>'), '');
}