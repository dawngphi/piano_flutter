import 'package:flutter/material.dart';

import '../logic/key.dart';

class KeyProps {
  final dynamic note;
  final bool highlighted;
  final int highlightColor;

  KeyProps({
    required this.note,
    required this.highlighted,
    required this.highlightColor,
  });
}

class KeyWidget extends StatefulWidget {
  final dynamic note;
  final bool highlighted;
  final int highlightColor;

  const KeyWidget({
    Key? key,
    required this.note,
    required this.highlighted,
    required this.highlightColor,
  }) : super(key: key);

  @override
  _KeyWidgetState createState() => _KeyWidgetState();
}

class _KeyWidgetState extends State<KeyWidget> {
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    // Equivalent to window.addEventListener('mouseup', this.pageMouseUp, false)
    // In Flutter, we handle this through GestureDetector's onPanEnd or onTapUp
  }

  void _handleTapDown(TapDownDetails details) {
    // Equivalent to handleMouseDown
    setState(() {
      clicked = true;
    });
    widget.note.play();
  }

  void _handleTapUp(TapUpDetails details) {
    // Equivalent to handleMouseUp
    setState(() {
      clicked = false;
    });
  }

  void _handleTapCancel() {
    // Equivalent to pageMouseUp - handles when tap is cancelled
    if (!clicked) return;
    setState(() {
      clicked = false;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    // Additional handling for when user drags away from the key
    if (!clicked) return;
    setState(() {
      clicked = false;
    });
  }

  String _getKeyClasses() {
    String baseClass = 'keyboard-key';
    String colorClass = widget.note.bw == BlackWhite.white ? 'white' : 'black';
    String clickedClass = clicked ? ' clicked' : '';
    String highlightClass = widget.highlighted
        ? ' active color-${widget.highlightColor}'
        : '';

    return '$baseClass $colorClass$clickedClass$highlightClass';
  }

  Color _getKeyColor() {
    if (widget.highlighted) {
      // Return highlight color based on highlightColor value
      switch (widget.highlightColor) {
        case 1:
          return Colors.blue.withOpacity(0.7);
        case 2:
          return Colors.red.withOpacity(0.7);
        case 3:
          return Colors.green.withOpacity(0.7);
        default:
          return Colors.blue.withOpacity(0.7);
      }
    }

    if (clicked) {
      return widget.note.bw == BlackWhite.white
          ? Colors.grey.shade300
          : Colors.grey.shade700;
    }

    return widget.note.bw == BlackWhite.white
        ? Colors.white
        : Colors.black;
  }

  Color _getTextColor() {
    return widget.note.bw == BlackWhite.white ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onPanEnd: _handlePanEnd,
      child: Container(
        width: widget.note.bw == BlackWhite.white ? 40 : 30,
        height: widget.note.bw == BlackWhite.white ? 120 : 80,
        margin: EdgeInsets.only(
          right: widget.note.bw == BlackWhite.white ? 2 : 0,
          left: widget.note.bw == BlackWhite.black ? -15 : 0,
        ),
        decoration: BoxDecoration(
          color: _getKeyColor(),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: clicked ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            widget.note.toString(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}