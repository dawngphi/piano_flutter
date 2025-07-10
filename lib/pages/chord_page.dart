import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/logic/constant.dart';
import 'package:piano/pages/playbox.dart';
import '../logic/helper.dart';
import '../logic/key.dart';
import 'chord_detail.dart';
import 'chord_selector.dart';
import 'key_board.dart';
import 'key_selector.dart';

const int maxOctaveAdj = 1;
const int minOctaveAdj = -1;

class ChordPage extends StatefulWidget {
  final String? selectedKey;
  final String? selectedChord;
  final String? inversion;

  const ChordPage({
    Key? key,
    this.selectedKey,
    this.selectedChord,
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
    // _updateTitle();
  }

  @override
  void didUpdateWidget(ChordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKey != widget.selectedKey ||
        oldWidget.selectedChord != widget.selectedChord ||
        oldWidget.inversion != widget.inversion) {
      _updateTitle();
    }
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTitle();
  }
  void _updateTitle() {
    final decoded = _urlDecode();
    String title = AppConstants.titlePrefix;

    if (decoded.selectedChord != null) {
      title += " - ${decoded.selectedChord}";
    } else if (decoded.selectedKey != null) {
      title += " - Key ${decoded.selectedKey}";
    }

    // In Flutter web, you can update the browser title
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor: Theme.of(context).primaryColor.value,
      ),
    );
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

  ({String? selectedKey, String? selectedChord, int inversion}) _urlDecode() {
    String? selectedKey = urlDecodeKey(widget.selectedKey);
    String? selectedChord = urlDecodeChord(widget.selectedChord);

    int inversion = 0;
    if (widget.inversion != null) {
      final parsed = int.tryParse(widget.inversion!);
      if (parsed != null && !parsed.isNaN) {
        inversion = parsed;
      }
    }

    return (
      selectedKey: selectedKey,
      selectedChord: selectedChord,
      inversion: inversion,
    );
  }

  void _navigateToNotFound() {
    Navigator.of(context).pushReplacementNamed('/404');
  }

  @override
  Widget build(BuildContext context) {
    final decoded = _urlDecode();
    final selectedKey = decoded.selectedKey;
    final selectedChord = decoded.selectedChord;
    final inversion = decoded.inversion;

    print("selectedKey = $selectedKey");
    print("selectedChord = $selectedChord");
    print("inversion = $inversion");
    final keyName123 = parseKeyName(selectedKey!);
    print("is key valid: ${keySimpleList.contains(keyName123)}");

    final chord12 = findChordByName(selectedKey!, selectedChord!);
    print("found chord: $chord12");

    final keyName12 = parseKeyName(selectedKey!);
    print("parsed keyName: $keyName12");
    // final chordList = chords['C'];
    // if (chordList != null) {
    //   for (var chord in chordList) {
    //     print('Alias for chord: ${chord.alias}');
    //   }
    // }


    // Validation checks
    if (selectedKey == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNotFound();
      });
      return const SizedBox.shrink();
    }

    final keyName = parseKeyName(selectedKey);
    if (keyName == null || !keySimpleList.contains(keyName)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNotFound();
      });
      return const SizedBox.shrink();
    }

    if (selectedChord != null) {
      return _buildChordView(selectedKey, selectedChord, inversion);
    } else {
      return _buildKeyView(selectedKey);
    }
  }


  Widget _buildChordView(
    String selectedKey,
    String selectedChord,
    int inversion,
  ) {
    final chord = findChordByName(selectedKey, selectedChord);

    if (chord == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNotFound();
      });
      return const SizedBox.shrink();
    }
    final keyName = parseKeyName(selectedKey);
    if (keyName == null || !keySimpleList.contains(keyName)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNotFound();
      });
      return const SizedBox.shrink();
    }
    List<bool> highlightTable;
    int colorIndex;

    if (inversion == 0) {
      highlightTable = chordAlignMid(getHighlightTable(chord));
      colorIndex = keySimpleList.indexOf(keyName) + 1;
    } else {
      if (chord.inversions.length < inversion) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToNotFound();
        });
        return const SizedBox.shrink();
      }

      highlightTable = chordAlignMid(
        getHighlightTable(chord.inversions[inversion - 1]),
      );
      colorIndex =
          keySimpleList
              .map((str) => keys[str]!)
              .toList()
              .indexOf(chord.inversions[inversion - 1].key) +
          1;
    }

    final color = keySimpleList.indexOf(keyName) + 1;



    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Keyboard(
              props: KeyboardProps(
                offset: octaveAdj,
                highlightTable: highlightTable,
                highlightColor: colorIndex,
              ),
            ),
            KeySelector(selectedKey: selectedKey, link: true),
            Playbox(
              offset: octaveAdj,
              highlightTable: highlightTable,
              raiseOctave: raiseOctave,
              lowerOctave: lowerOctave,
              risingDisabled: octaveAdj == maxOctaveAdj,
              lowerDisabled: octaveAdj == minOctaveAdj,
              color: color,
            ),
            ChordDetail(chord: chord, inversion: inversion, color: color),
            ChordSelector(selectedKey: keyName),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyView(String selectedKey) {

    final keyName = parseKeyName(selectedKey);
    if (keyName == null) {
      _navigateToNotFound();
      return const SizedBox.shrink();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Keyboard(props: KeyboardProps(offset: 0)),
            KeySelector(selectedKey: selectedKey, link: true),
            ChordSelector(selectedKey: keyName),
          ],
        ),
      ),
    );
  }
}
