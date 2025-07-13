import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_event.dart';
import '../logic/key.dart';
import '../logic/helper.dart';

class KeySelector extends StatelessWidget {
  final String? selectedKey;
  final bool link;
  // Bỏ setKey vì sẽ dùng Bloc

  const KeySelector({
    Key? key,
    this.selectedKey,
    required this.link,
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
      return GestureDetector(
        onTap: () {
          try {
            final encodedKey = urlEncodeKey(keyString);
            print("urlEncodeKey$urlEncodeKey");
            // Gửi event Bloc khi chọn phím
            context.read<AppBloc>().add(SelectKeyEvent(keyName: keyString));
            Navigator.pushNamed(context, '/chord/$encodedKey/Maj');
          } catch (e) {
            debugPrint('Error navigating to chord page: $e');
          }
        },
        child: widget,
      );
    } else {
      return GestureDetector(
        onTap: () {
          try {
            context.read<AppBloc>().add(SelectKeyEvent(keyName: keyString));
          } catch (e) {
            debugPrint('Error calling setKey: $e');
          }
        },
        child: widget,
      );
    }
  }

  Color _getColorForIndex(int colorIndex) {
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
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepPurple,
      Colors.brown,
    ];
    if (colorIndex >= 0 && colorIndex < colors.length) {
      return colors[colorIndex];
    }
    return Colors.grey;
  }
}