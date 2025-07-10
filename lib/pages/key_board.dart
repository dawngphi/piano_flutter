import 'package:flutter/material.dart';
import '../logic/db.dart';
import '../logic/key.dart';
import 'key_page.dart';

class KeyboardProps {
  final int offset;
  final List<bool>? highlightTable;
  final int? highlightColor;

  KeyboardProps({
    required this.offset,
    this.highlightTable,
    this.highlightColor,
  });
}

class Keyboard extends StatefulWidget {
  final KeyboardProps props;

  const Keyboard({Key? key, required this.props}) : super(key: key);

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keyKeys = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo keys cho mỗi nốt nhạc (36 phím)
    for (int i = 0; i < 36; i++) {
      _keyKeys.add(GlobalKey());
    }
  }

  @override
  void didUpdateWidget(Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.props.highlightTable != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollHighlightedKeysIntoView();
      });
    }
  }

  void _scrollHighlightedKeysIntoView() {
    if (widget.props.highlightTable == null) return;

    final highlightTable = _createSafeHighlightTable();

    final firstIndex = highlightTable.indexWhere((item) => item == true);
    final lastIndex = highlightTable.lastIndexWhere((item) => item == true);

    if (firstIndex != -1 && lastIndex != -1) {
      // Cuộn đến phím được highlight cuối cùng trước
      if (_keyKeys[lastIndex].currentContext != null) {
        Scrollable.ensureVisible(
          _keyKeys[lastIndex].currentContext!,
          duration: const Duration(milliseconds: 300),
        );
      }

      // Sau đó cuộn đến phím được highlight đầu tiên
      if (_keyKeys[firstIndex].currentContext != null) {
        Scrollable.ensureVisible(
          _keyKeys[firstIndex].currentContext!,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  // Phương thức helper để đảm bảo highlightTable luôn có đúng 36 phần tử
  List<bool> _createSafeHighlightTable() {
    if (widget.props.highlightTable == null) {
      return List.filled(36, false);
    }

    final originalTable = widget.props.highlightTable!;

    if (originalTable.length == 36) {
      return originalTable;
    }

    List<bool> safeTable = List.filled(36, false);

    // Copy các giá trị gốc đến số lượng tối thiểu của cả hai độ dài
    final copyLength = originalTable.length < 36 ? originalTable.length : 36;
    for (int i = 0; i < copyLength; i++) {
      safeTable[i] = originalTable[i];
    }

    return safeTable;
  }

  @override
  Widget build(BuildContext context) {
    int offset = 12 * (1 + widget.props.offset);
    List<dynamic> notes = allNotes.sublist(offset, offset + 36);
    List<bool> highlightTable = _createSafeHighlightTable();
    int highlightColor = widget.props.highlightColor ?? 1;

    // Tách các phím trắng và đen
    List<Widget> whiteKeys = [];
    List<Widget> blackKeys = [];
    double currentPosition = 0;

    for (int index = 0; index < notes.length; index++) {
      final note = notes[index];
      final isWhiteKey = note.bw == BlackWhite.white;

      if (isWhiteKey) {
        whiteKeys.add(
          Positioned(
            left: currentPosition,
            child: KeyWidget(
              key: _keyKeys[index],
              note: note,
              highlighted: highlightTable[index],
              highlightColor: highlightColor,
            ),
          ),
        );
        currentPosition += 42; // 40 width + 2 margin
      } else {
        // Phím đen được đặt giữa các phím trắng
        blackKeys.add(
          Positioned(
            left: currentPosition - 21, // Đặt ở giữa phím trắng trước đó
            child: KeyWidget(
              key: _keyKeys[index],
              note: note,
              highlighted: highlightTable[index],
              highlightColor: highlightColor,
            ),
          ),
        );
      }
    }

    return Container(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 120,
          width: currentPosition,
          child: Stack(
            children: [
              ...whiteKeys,
              ...blackKeys,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}