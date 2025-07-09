import 'package:flutter/material.dart';
import '../logic/key.dart';
import '../logic/helper.dart';

class KeySelector extends StatelessWidget {
  final String? selectedKey;
  final bool link;
  final Function(KeyName)? setKey;

  const KeySelector({
    Key? key,
    this.selectedKey,
    required this.link,
    this.setKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("selectedKey trong key_select$selectedKey");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: keySimpleList.asMap().entries.map((entry) {
          final i = entry.key;
          final keyName = entry.value;
          final keyString = keyName.name;
          final isActive = selectedKey == keyString;

          return _buildKeyButton(
            context,
            keyName,
            keyString,
            i + 1,
            isActive,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyButton(
      BuildContext context,
      KeyName keyName,
      String keyString,
      int colorIndex,
      bool isActive,
      ) {
    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getColorForIndex(colorIndex),
        borderRadius: BorderRadius.circular(4),
        border: isActive
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        keyString,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );

    if (link) {
      // Equivalent to <a href={'/chord/' + urlEncodeKey(key) + '/'}>
      return GestureDetector(
        onTap: () {
          try {
            final encodedKey = urlEncodeKey(keyString);
            print("urlEncodeKey$urlEncodeKey");
            Navigator.pushNamed(context, '/chord/$encodedKey/Maj');
          } catch (e) {
            debugPrint('Error navigating to chord page: $e');
          }
        },
        child: widget,
      );
    } else {
      // Equivalent to <div onClick={() => { if (this.props.setKey) this.props.setKey(key) }}>
      return GestureDetector(
        onTap: () {
          try {
            if (setKey != null) {
              setKey!(keyName);
            }
          } catch (e) {
            debugPrint('Error calling setKey: $e');
          }
        },
        child: widget,
      );
    }
  }

  Color _getColorForIndex(int index) {
    // Equivalent to CSS classes 'color-1', 'color-2', etc.
    const colors = [
      Color(0xFFE53E3E),   // color-1: Red
      Color(0xFFD53F8C),   // color-2: Pink
      Color(0xFF9F7AEA),   // color-3: Purple
      Color(0xFF667EEA),   // color-4: Indigo
      Color(0xFF4299E1),   // color-5: Blue
      Color(0xFF0BC5EA),   // color-6: Cyan
      Color(0xFF00B5D8),   // color-7: Teal
      Color(0xFF38A169),   // color-8: Green
      Color(0xFF68D391),   // color-9: Light Green
      Color(0xFFD69E2E),   // color-10: Yellow
      Color(0xFFED8936),   // color-11: Orange
      Color(0xFFE53E3E),   // color-12: Red (repeat)
    ];

    return colors[(index - 1) % colors.length];
  }
}