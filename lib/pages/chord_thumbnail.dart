import 'package:flutter/material.dart';
import '../logic/chord.dart';
import '../logic/helper.dart';
import '../logic/key.dart';

class ChordThumbnail extends StatelessWidget {
  final Chord chord;
  final int highlightColor;

  const ChordThumbnail({
    Key? key,
    required this.chord,
    required this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final highlightTable = getHighlightTable(chord);
    final octaves = (highlightTable.length / 12).ceil();

    return CustomPaint(
      size: Size(
        _ChordThumbnailPainter.whiteWidth * 7 * octaves,
        _ChordThumbnailPainter.whiteHeight,
      ),
      painter: _ChordThumbnailPainter(
        highlightTable: highlightTable,
        highlightColor: highlightColor,
        octaves: octaves,
      ),
    );
  }
}

class _ChordThumbnailPainter extends CustomPainter {
  static const double whiteWidth = 9.0;
  static const double whiteHeight = 40.0;
  static const double blackWidth = 4.5;
  static const double blackHeight = 25.0;

  final List<bool> highlightTable;
  final int highlightColor;
  final int octaves;

  // Tính toán các chỉ số phím đen và trắng cho 3 octave
  late final List<int> blackOccurIndex;
  late final List<int> whiteOccurIndex;
  late final List<BlackWhite> bwMap3x;

  _ChordThumbnailPainter({
    required this.highlightTable,
    required this.highlightColor,
    required this.octaves,
  }) {
    _initializeIndexes();
  }

  void _initializeIndexes() {
    // Khởi tạo chỉ số phím đen
    List<int> baseBlackIndex = [1, 3, 6, 8, 10];
    blackOccurIndex = [
      ...baseBlackIndex,
      ...baseBlackIndex.map((i) => i + bwMap.length),
      ...baseBlackIndex.map((i) => i + bwMap.length * 2),
    ];

    // Khởi tạo chỉ số phím trắng
    List<int> baseWhiteIndex = [0, 2, 4, 5, 7, 9, 11];
    whiteOccurIndex = [
      ...baseWhiteIndex,
      ...baseWhiteIndex.map((i) => i + bwMap.length),
      ...baseWhiteIndex.map((i) => i + bwMap.length * 2),
    ];

    // Tạo bản đồ bwMap cho 3 octave
    bwMap3x = [...bwMap, ...bwMap, ...bwMap];
  }

  bool _whiteIfActive(int i) {
    if (i >= whiteOccurIndex.length) return false;
    final index = whiteOccurIndex[i];
    return index < highlightTable.length && highlightTable[index];
  }

  bool _blackIfActive(int i) {
    if (i >= blackOccurIndex.length) return false;
    final index = blackOccurIndex[i];
    return index < highlightTable.length && highlightTable[index];
  }

  Color _getHighlightColor() {
    // Định nghĩa các màu highlight dựa trên highlightColor index
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    if (highlightColor >= 0 && highlightColor < colors.length) {
      return colors[highlightColor];
    }
    return Colors.red; // Màu mặc định
  }

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final whiteStrokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = _getHighlightColor()
      ..style = PaintingStyle.fill;

    // Vẽ các phím trắng
    for (int i = 0; i < 7 * octaves; i++) {
      final rect = Rect.fromLTWH(
        whiteWidth * i,
        0,
        whiteWidth,
        whiteHeight,
      );

      // Vẽ nền phím trắng
      canvas.drawRect(rect, whitePaint);

      // Vẽ highlight nếu phím được kích hoạt
      if (_whiteIfActive(i)) {
        canvas.drawRect(rect, highlightPaint);
      }

      // Vẽ viền
      canvas.drawRect(rect, whiteStrokePaint);
    }

    // Vẽ các phím đen
    for (int i = 0; i < 5 * octaves; i++) {
      if (i >= blackOccurIndex.length) break;

      // Tính toán vị trí x của phím đen
      final blackIndex = blackOccurIndex[i];
      final whiteKeysBeforeBlack = bwMap3x
          .take(blackIndex)
          .where((x) => x == BlackWhite.white)
          .length;

      final x = whiteWidth * whiteKeysBeforeBlack - blackWidth / 2;

      final rect = Rect.fromLTWH(
        x,
        0,
        blackWidth,
        blackHeight,
      );

      // Vẽ phím đen
      if (_blackIfActive(i)) {
        // Nếu được kích hoạt, vẽ với màu highlight
        canvas.drawRect(rect, highlightPaint);
      } else {
        // Vẽ phím đen bình thường
        canvas.drawRect(rect, blackPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChordThumbnailPainter oldDelegate) {
    return oldDelegate.highlightTable != highlightTable ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.octaves != octaves;
  }
}