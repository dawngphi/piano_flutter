import 'package:flutter/material.dart';
import '../logic/key.dart';
import '../logic/note.dart';

class KeyWidget extends StatefulWidget {
  final Note note;
  final bool highlighted;
  final int highlightColor;

  const KeyWidget({
    Key? key,
    required this.note,
    required this.highlighted,
    required this.highlightColor,
  }) : super(key: key);

  @override
  State<KeyWidget> createState() => _KeyWidgetState();
}

class _KeyWidgetState extends State<KeyWidget> {
  bool clicked = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      clicked = true;
    });
    widget.note.play();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      clicked = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      clicked = false;
    });
  }

  Color _getHighlightColor() {
    // Define your color palette here
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.brown,
    ];

    if (widget.highlightColor >= 0 && widget.highlightColor < colors.length) {
      return colors[widget.highlightColor];
    }
    return Colors.red; // Default color
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final isWhiteKey = note.bw == BlackWhite.white;

    // Key dimensions
    final keyWidth = isWhiteKey ? 40.0 : 24.0;
    final keyHeight = isWhiteKey ? 120.0 : 80.0;

    // Base colors
    Color baseColor;
    Color pressedColor;
    Color borderColor;

    if (isWhiteKey) {
      baseColor = Colors.white;
      pressedColor = Colors.grey.shade300;
      borderColor = Colors.grey.shade400;
    } else {
      baseColor = Colors.grey.shade900;
      pressedColor = Colors.grey.shade700;
      borderColor = Colors.grey.shade800;
    }

    // Apply highlight color if highlighted
    if (widget.highlighted) {
      final highlightColor = _getHighlightColor();
      baseColor = highlightColor.withOpacity(0.7);
      pressedColor = highlightColor.withOpacity(0.9);
    }

    // Apply clicked state
    final currentColor = clicked ? pressedColor : baseColor;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: keyWidth,
        height: keyHeight,
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
        decoration: BoxDecoration(
          color: currentColor,
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: clicked
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                note.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isWhiteKey
                      ? (widget.highlighted ? Colors.white : Colors.black87)
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}