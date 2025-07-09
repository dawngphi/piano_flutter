import 'package:flutter/material.dart';
import '../logic/db.dart';
import '../logic/note.dart';
import 'key_page.dart';

class Keyboard extends StatefulWidget {
  final int offset;
  final List<bool>? highlightTable;
  final int? highlightColor;

  const Keyboard({
    Key? key,
    required this.offset,
    this.highlightTable,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _keyWidgetKeys = {}; // Sửa thành map để tránh lỗi null

  @override
  void didUpdateWidget(Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.highlightTable != null &&
        widget.highlightTable != oldWidget.highlightTable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedKeys();
      });
    }
  }

  void _scrollToHighlightedKeys() {
    final table = widget.highlightTable;
    if (table == null) return;

    final firstIndex = table.indexWhere((item) => item == true);
    final lastIndex = table.lastIndexOf(true);

    if (firstIndex == -1 || lastIndex == -1) return;

    final firstKeyContext = _keyWidgetKeys[firstIndex]?.currentContext;
    final lastKeyContext = _keyWidgetKeys[lastIndex]?.currentContext;

    if (firstKeyContext == null || lastKeyContext == null) return;

    final firstBox = firstKeyContext.findRenderObject() as RenderBox;
    final firstOffset = firstBox.localToGlobal(Offset.zero);

    final scrollOffset = firstOffset.dx - 40;

    _scrollController.animateTo(
      scrollOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = 12 * (1 + widget.offset);
    final keyNotes = notes.sublist(offset, offset + 36);
    final highlightTable = widget.highlightTable ?? List.filled(36, false);
    final highlightColor = widget.highlightColor ?? 1;

    _keyWidgetKeys.clear(); // reset keys cho mỗi lần build

    return Container(
      height: 140,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildWhiteKeys(keyNotes, highlightTable, highlightColor),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBlackKeys(keyNotes, highlightTable, highlightColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWhiteKeys(List<Note> keyNotes, List<bool> highlightTable, int highlightColor) {
    List<Widget> whiteKeys = [];

    for (int i = 0; i < keyNotes.length; i++) {
      final note = keyNotes[i];
      if (note.isWhite) {
        final key = GlobalKey();
        _keyWidgetKeys[i] = key;

        whiteKeys.add(
          KeyWidget(
            key: key,
            note: note,
            highlighted: highlightTable[i],
            highlightColor: highlightColor,
          ),
        );
      }
    }

    return whiteKeys;
  }

  List<Widget> _buildBlackKeys(List<Note> keyNotes, List<bool> highlightTable, int highlightColor) {
    List<Widget> blackKeys = [];
    int whiteKeyCount = 0;

    for (int i = 0; i < keyNotes.length; i++) {
      final note = keyNotes[i];

      if (note.isWhite) {
        blackKeys.add(const SizedBox(width: 40, height: 80));
        whiteKeyCount++;
      } else {
        final key = GlobalKey();
        _keyWidgetKeys[i] = key;

        blackKeys.add(
          Padding(
            padding: EdgeInsets.only(left: (whiteKeyCount * 40.0) - 12),
            child: KeyWidget(
              key: key,
              note: note,
              highlighted: highlightTable[i],
              highlightColor: highlightColor,
            ),
          ),
        );
      }
    }

    return blackKeys;
  }
}
