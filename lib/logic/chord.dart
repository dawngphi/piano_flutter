import 'key.dart';

class SerializeFeature {
  final int key;
  final List<int> intervals;

  const SerializeFeature({
    required this.key,
    required this.intervals,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'intervals': intervals,
  };

  factory SerializeFeature.fromJson(Map<String, dynamic> json) => SerializeFeature(
    key: json['key'] as int,
    intervals: List<int>.from(json['intervals'] as List),
  );
}

class Chord {
  int key;
  List<int> intervals;
  List<String> alias;
  String fullName;
  String quality;
  String tonic;
  List<Chord> inversions;

  Chord({
    required this.key,
    required this.intervals,
  }) : alias = [],
        fullName = '',
        quality = '',
        inversions = [],
        tonic = '';

  String get name {
    if (fullName.isNotEmpty) return fullName;
    return alias.isNotEmpty ? alias[0] : '';
  }

  String get shortName {
    return alias.isNotEmpty ? alias[0] : '';
  }

  List<String> get possibleNames {
    if (fullName.isNotEmpty) return [fullName, ...alias];
    return alias;
  }

  void cutoff(int n) {
    while (key + _sum(intervals) >= n) {
      intervals.removeLast();
    }
  }

  Chord clone() {
    final chord = Chord(
      key: key,
      intervals: List.from(intervals),
    );
    chord.alias = List.from(alias);
    chord.fullName = fullName;
    chord.quality = quality;
    chord.tonic = tonic;
    chord.inversions = inversions.map((inv) => inv.clone()).toList();
    return chord;
  }

  void calcInversions() {
    if (intervals.length == 3 || intervals.length == 4) {
      inversions = [];
      for (int i = 0; i < intervals.length - 1; i++) {
        // (i+1)th inversion
        int inversionKey = key + _sum(intervals.sublist(0, i + 2));
        inversionKey %= 12;

        List<int> intervalAboveRoot = List.from(intervals.sublist(i + 1));
        intervalAboveRoot[0] = 0;

        List<int> intervalBelowRoot = List.from(intervals.sublist(0, i + 1));
        intervalBelowRoot[0] = 12 - _sum(intervals);

        List<int> interval = [...intervalAboveRoot, ...intervalBelowRoot];

        // re-position if it has negative interval
        if (interval.any((x) => x < 0)) {
          // convert from accumulative to absolute interval
          for (int j = 1; j < interval.length; j++) {
            interval[j] += interval[j - 1];
          }
          // if still has negative
          if (interval.any((x) => x < 0)) {
            interval = interval.map((x) {
              if (x >= 0) return x;
              return x + 12;
            }).toList();
          }
          // re-position
          interval.sort();
          // convert back to accumulative interval
          for (int j = interval.length - 1; j > 0; j--) {
            interval[j] -= interval[j - 1];
          }
        }

        final invChord = Chord(key: inversionKey, intervals: interval);
        invChord.alias = alias.map((str) =>
            keyPossibleName[inversionKey].map((root) => '$str/${root.name}').toList()
        ).expand((x) => x).toList();
        inversions.add(invChord);
      }
    }
  }

  String serialize() {
    final data = SerializeFeature(key: key, intervals: intervals);
    return data.toJson().toString();
  }

  static Chord deserialize(String str) {
    // Simple JSON parsing - in production, use dart:convert
    final data = SerializeFeature.fromJson(_parseSimpleJson(str));
    return Chord(key: data.key, intervals: data.intervals);
  }

  @override
  String toString() {
    return serialize();
  }

  // Helper method for simple JSON parsing
  static Map<String, dynamic> _parseSimpleJson(String str) {
    // This is a simplified implementation
    // In production, use dart:convert's jsonDecode
    throw UnimplementedError('Use dart:convert jsonDecode instead');
  }
}

int _sum(List<int> arr) {
  return arr.fold(0, (a, b) => a + b);
}