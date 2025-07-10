import 'audio.dart';
import 'key.dart';

class Note {
  KeyName key;
  Octave octave;

  Note(this.key, this.octave);

  Future<void> play() {
    return piano.play(keys[key]!, octave);
  }

  @override
  String toString() {
    return '${chromaticName[keys[key]!]}${octave.value}';
  }


  int valueOf() {
    return octave.value * octaveKeyCount + keys[key]!;
  }

  get bw {
    return bwMap[keys[key]!];
  }

  // Override equality operator for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.key == key && other.octave == octave;
  }

  @override
  int get hashCode => key.hashCode ^ octave.hashCode;

}
