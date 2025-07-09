import 'package:flutter/material.dart';
import 'package:piano/pages/playbox.dart';
import '../logic/chord.dart';
import '../logic/constant.dart';
import '../logic/helper.dart';
import '../logic/key.dart';
import '../logic/db.dart';
import 'chord_detail.dart';
import 'chord_selector.dart';
import 'key_board.dart';
import 'key_selector.dart';

const int maxOctaveAdj = 1;
const int minOctaveAdj = -1;

class ChordPageArguments {
  final String? selectedKey;
  final String? selectedChord;
  final String? path;
  final String? inversion;

  ChordPageArguments({
    this.selectedKey,
    this.selectedChord,
    this.path,
    this.inversion,
  });
}

class ChordPage extends StatefulWidget {
  final String? selectedKey;
  final String? selectedChord;
  final String? path;
  final String? inversion;

  const ChordPage({
    Key? key,
    this.selectedKey,
    this.selectedChord,
    this.path,
    this.inversion,
  }) : super(key: key);

  @override
  State<ChordPage> createState() => _ChordPageState();
}

class _ChordPageState extends State<ChordPage> {
  int octaveAdj = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitle();
    });
  }

  @override
  void didUpdateWidget(ChordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKey != widget.selectedKey ||
        oldWidget.selectedChord != widget.selectedChord ||
        oldWidget.inversion != widget.inversion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTitle();
      });
    }
  }

  void raiseOctave() {
    setState(() {
      octaveAdj += 1;
      if (octaveAdj > maxOctaveAdj) octaveAdj = maxOctaveAdj;
    });
  }

  void lowerOctave() {
    setState(() {
      octaveAdj -= 1;
      if (octaveAdj < minOctaveAdj) octaveAdj = minOctaveAdj;
    });
  }

  Map<String, dynamic> urlDecode() {
    String? selectedKey = urlDecodeKey(widget.selectedKey);
    String? selectedChord = urlDecodeChord(widget.selectedChord);
    int inversion;

    if (widget.inversion == null || widget.inversion!.isEmpty) {
      inversion = 0;
    } else {
      inversion = int.tryParse(widget.inversion!) ?? 0;
    }

    return {
      'selectedKey': selectedKey,
      'selectedChord': selectedChord,
      'inversion': inversion,
    };
  }

  void _updateTitle() {
    final decoded = urlDecode();
    final selectedKey = decoded['selectedKey'] as String?;
    final selectedChord = decoded['selectedChord'] as String?;

    String title = AppConstants.titlePrefix;
    if (selectedChord != null) {
      title += " - $selectedChord";
    } else if (selectedKey != null) {
      title += " - Key $selectedKey";
    }
    debugPrint("Title: $title");
  }

  void _navigateToNotFound() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/404');
    }
  }

  Chord? findChordByName(String keyName, String chordName) {
    final keyChords = chords[keyName];
    if (keyChords == null) return null;

    try {
      return keyChords.firstWhere(
            (chord) {
          if (chord.fullName == chordName) return true;
          if (chord.alias.contains(chordName)) return true;
          return false;
        },
      );
    } catch (e) {
      return null;
    }
  }

  // Helper method để đảm bảo highlightTable có đúng length
  List<bool> _ensureHighlightTableLength(List<bool> highlightTable, int expectedLength) {
    if (highlightTable.length == expectedLength) {
      return highlightTable;
    } else if (highlightTable.length < expectedLength) {
      // Nếu ngắn hơn, thêm false vào cuối
      return [...highlightTable, ...List.filled(expectedLength - highlightTable.length, false)];
    } else {
      // Nếu dài hơn, cắt bớt
      return highlightTable.sublist(0, expectedLength);
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoded = urlDecode();
    final selectedKeyStr = decoded['selectedKey'] as String?;
    final selectedChord = decoded['selectedChord'] as String?;
    final inversion = decoded['inversion'] as int;

    // Kiểm tra selectedKey có hợp lệ không
    if (selectedKeyStr == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToNotFound());
      return const SizedBox.shrink();
    }

    // Tìm KeyName từ string
    KeyName? selectedKeyNullable;
    try {
      selectedKeyNullable = keySimpleList.firstWhere(
            (key) => key.name == selectedKeyStr,
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToNotFound());
      return const SizedBox.shrink();
    }

    final KeyName selectedKey = selectedKeyNullable;

    if (selectedChord != null) {
      final chord = findChordByName(selectedKeyStr, selectedChord);
      if (chord == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToNotFound());
        return const SizedBox.shrink();
      }

      List<bool> highlightTable;
      int colorIndex;

      if (inversion == 0) {
        highlightTable = chordAlignMid(getHighlightTable(chord));
        colorIndex = keySimpleList.indexOf(selectedKey) + 1;
      } else {
        if (chord.inversions.length < inversion) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToNotFound());
          return const SizedBox.shrink();
        }
        highlightTable = chordAlignMid(getHighlightTable(chord.inversions[inversion - 1]));
        colorIndex = keySimpleList
            .map((k) => keys[k])
            .toList()
            .indexOf(chord.inversions[inversion - 1].key) + 1;
      }

      final color = keySimpleList.indexOf(selectedKey) + 1;

      // Đảm bảo highlightTable có đúng length (36 keys cho 3 octaves)
      highlightTable = _ensureHighlightTableLength(highlightTable, 36);

      debugPrint("highlightTable length: ${highlightTable.length}");
      debugPrint("octaveAdj: $octaveAdj");

      return Scaffold(
        body: ListView(
          children: [
            Keyboard(
              offset: octaveAdj,
              highlightTable: highlightTable,
              highlightColor: colorIndex,
            ),
            KeySelector(
              selectedKey: selectedKey.name,
              link: true,
            ),
            Playbox(
              offset: octaveAdj,
              highlightTable: highlightTable,
              raiseOctave: raiseOctave,
              lowerOctave: lowerOctave,
              risingDisabled: octaveAdj == maxOctaveAdj,
              lowerDisabled: octaveAdj == minOctaveAdj,
              color: color,
            ),
            ChordDetail(
              chord: chord,
              inversion: inversion,
              color: color,
            ),
            ChordSelector(selectedKey: selectedKey),
          ],
        ),
      );
    } else {
      // Không có chord được chọn, hiển thị key selection view
      return Scaffold(
        body: ListView(
          children: [
            const Keyboard(offset: 0),
            KeySelector(
              selectedKey: selectedKey.name,
              link: true,
            ),
            ChordSelector(selectedKey: selectedKey),
          ],
        ),
      );
    }
  }
}

// Extension class for route handling
class ChordPageRoute extends MaterialPageRoute<void> {
  ChordPageRoute({
    required String? selectedKey,
    required String? selectedChord,
    required String? inversion,
  }) : super(
    builder: (context) => ChordPage(
      selectedKey: selectedKey,
      selectedChord: selectedChord,
      inversion: inversion,
    ),
  );
}

// Helper function to create route from URL parameters
Route<dynamic> generateChordPageRoute(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '');
  final pathSegments = uri.pathSegments;

  if (pathSegments.length >= 2 && pathSegments[0] == 'chord') {
    final selectedKey = pathSegments[1];
    final selectedChord = pathSegments.length > 2 ? pathSegments[2] : null;
    final inversion = pathSegments.length > 3 ? pathSegments[3] : null;

    return ChordPageRoute(
      selectedKey: selectedKey,
      selectedChord: selectedChord,
      inversion: inversion,
    );
  }

  // Return 404 route if path doesn't match
  return MaterialPageRoute(
    builder: (context) => const NotFoundPage(),
  );
}

// Placeholder for 404 page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('The requested page could not be found.'),
          ],
        ),
      ),
    );
  }
}