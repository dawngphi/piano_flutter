import 'package:flutter/material.dart';
import '../logic/db.dart';
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
    // Initialize keys for each note (36 keys)
    for (int i = 0; i < 36; i++) {
      _keyKeys.add(GlobalKey());
    }
  }

  @override
  void didUpdateWidget(Keyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Equivalent to componentDidUpdate - scroll highlighted keys into view
    if (widget.props.highlightTable != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollHighlightedKeysIntoView();
      });
    }
  }

  void _scrollHighlightedKeysIntoView() {
    if (widget.props.highlightTable == null) return;

    final firstIndex = widget.props.highlightTable!.indexWhere((item) => item == true);
    final lastIndex = widget.props.highlightTable!.lastIndexWhere((item) => item == true);

    if (firstIndex != -1 && lastIndex != -1) {
      // Scroll to the last highlighted key first
      if (_keyKeys[lastIndex].currentContext != null) {
        Scrollable.ensureVisible(
          _keyKeys[lastIndex].currentContext!,
          duration: const Duration(milliseconds: 300),
        );
      }

      // Then scroll to the first highlighted key
      if (_keyKeys[firstIndex].currentContext != null) {
        Scrollable.ensureVisible(
          _keyKeys[firstIndex].currentContext!,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int offset = 12 * (1 + widget.props.offset);
    List<dynamic> notes = allNotes.sublist(offset, offset + 36);
    List<bool> highlightTable = widget.props.highlightTable ?? List.filled(36, false);
    int highlightColor = widget.props.highlightColor ?? 1;

    return Container(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: notes.asMap().entries.map((entry) {
            int index = entry.key;
            dynamic note = entry.value;

            return KeyWidget(
              key: _keyKeys[index],
              note: note,
              highlighted: highlightTable[index],
              highlightColor: highlightColor,
            );
          }).toList(),
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