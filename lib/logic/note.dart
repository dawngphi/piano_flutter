import 'key.dart';
import 'audio.dart';

class Note {
  final KeyName key;
  final Octave octave;

  const Note({
    required this.key,
    required this.octave,
  });

  /// Phát âm thanh của nốt nhạc
  Future<void> play() async {
    return piano.play(keys[key]!, octave);
  }

  /// Chuyển đổi nốt nhạc thành chuỗi (ví dụ: "C4", "F#5")
  @override
  String toString() {
    return chromaticName[keys[key]!].name + octave.value.toString();
  }

  /// Trả về giá trị số của nốt nhạc (dùng để so sánh và sắp xếp)
  int valueOf() {
    return octave.value * octaveKeyCount + keys[key]!;
  }

  /// Trả về màu phím (trắng hoặc đen) của nốt nhạc
  BlackWhite get bw {
    return bwMap[keys[key]!];
  }

  /// So sánh hai nốt nhạc
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note &&
        other.key == key &&
        other.octave == octave;
  }

  @override
  int get hashCode => key.hashCode ^ octave.hashCode;

  /// So sánh để sắp xếp các nốt nhạc
  int compareTo(Note other) {
    return valueOf().compareTo(other.valueOf());
  }

  /// Tạo nốt nhạc từ giá trị số
  factory Note.fromValue(int value) {
    final octaveValue = (value / octaveKeyCount).floor();
    final keyValue = value % octaveKeyCount;

    // Tìm KeyName từ giá trị key
    final keyName = keys.entries
        .firstWhere((entry) => entry.value == keyValue)
        .key;

    // Tìm Octave từ giá trị octave
    final octave = Octave.values
        .firstWhere((oct) => oct.value == octaveValue);

    return Note(key: keyName, octave: octave);
  }

  /// Tạo nốt nhạc từ chuỗi (ví dụ: "C4", "F#5")
  factory Note.fromString(String noteString) {
    if (noteString.length < 2) {
      throw ArgumentError('Chuỗi nốt nhạc không hợp lệ: $noteString');
    }

    // Tách phần tên nốt và octave
    final octaveStr = noteString.substring(noteString.length - 1);
    final keyStr = noteString.substring(0, noteString.length - 1);

    // Chuyển đổi octave
    final octaveValue = int.tryParse(octaveStr);
    if (octaveValue == null) {
      throw ArgumentError('Octave không hợp lệ: $octaveStr');
    }

    final octave = Octave.values
        .where((oct) => oct.value == octaveValue)
        .firstOrNull;
    if (octave == null) {
      throw ArgumentError('Octave không được hỗ trợ: $octaveValue');
    }

    // Tìm KeyName
    final keyName = KeyName.values
        .where((key) => key.name == keyStr)
        .firstOrNull;
    if (keyName == null) {
      throw ArgumentError('Tên nốt không hợp lệ: $keyStr');
    }

    return Note(key: keyName, octave: octave);
  }

  /// Tăng nốt nhạc lên một số bán cung
  Note transpose(int semitones) {
    final currentValue = valueOf();
    final newValue = currentValue + semitones;

    // Kiểm tra giới hạn
    if (newValue < 0 || newValue >= (Octave.values.length * octaveKeyCount)) {
      throw ArgumentError('Nốt nhạc vượt quá phạm vi sau khi chuyển điệu');
    }

    return Note.fromValue(newValue);
  }

  /// Lấy nốt nhạc tiếp theo
  Note get next {
    return transpose(1);
  }

  /// Lấy nốt nhạc trước đó
  Note get previous {
    return transpose(-1);
  }

  /// Kiểm tra xem có phải là phím đen không
  bool get isBlack {
    return bw == BlackWhite.black;
  }

  /// Kiểm tra xem có phải là phím trắng không
  bool get isWhite {
    return bw == BlackWhite.white;
  }

  /// Lấy tên nốt nhạc (không có octave)
  String get noteName {
    return key.name;
  }

  /// Sao chép nốt nhạc với các tham số mới
  Note copyWith({
    KeyName? key,
    Octave? octave,
  }) {
    return Note(
      key: key ?? this.key,
      octave: octave ?? this.octave,
    );
  }
}