import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/logic/constant.dart';
import 'package:piano/pages/playbox.dart';
import '../logic/helper.dart';
import '../logic/key.dart';
import '../logic/chord.dart';
import 'chord_detail.dart';
import 'chord_selector.dart';
import 'key_board.dart';
import 'key_selector.dart';

const int maxOctaveAdj = 1;
const int minOctaveAdj = -1;

class ChordPageFull extends StatefulWidget {
  final String? selectedKey;
  final String? selectedChord;
  final String? inversion;

  const ChordPageFull({
    Key? key,
    this.selectedKey,
    this.selectedChord,
    this.inversion,
  }) : super(key: key);

  @override
  State<ChordPageFull> createState() => _ChordPageFullState();
}

class _ChordPageFullState extends State<ChordPageFull> {
  int octaveAdj = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ChordPageFull oldWidget) {
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
      title += " - 0{decoded.selectedChord}";
    } else if (decoded.selectedKey != null) {
      title += " - Key 0{decoded.selectedKey}";
    }

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
    print('selectedKey: $selectedKey');
    print('selectedChord: $selectedChord');
    print('inversion: $inversion');
    final chord = findChordByName(selectedKey!, selectedChord!);
    print('Chord found: $chord');
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
      final chord = findChordByName(selectedKey, selectedChord);
      if (chord == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToNotFound();
        });
        return const SizedBox.shrink();
      }

      // Xử lý inversion
      final Chord chordToShow = (inversion == 0)
          ? chord
          : (chord.inversions.length >= inversion ? chord.inversions[inversion - 1] : chord);

      List<bool> highlightTable = getHighlightTable(chordToShow);
      highlightTable = chordAlignMid(highlightTable);

      int colorIndex;
      if (inversion == 0) {
        colorIndex = keySimpleList.indexOf(parseKeyName(selectedKey) ?? KeyName.c);
      } else {
        final invKey = chordToShow.key;
        colorIndex = keySimpleList.indexWhere((k) => keys[k] == invKey);
        if (colorIndex == -1) colorIndex = 0;
      }
      final color = keySimpleList.indexOf(parseKeyName(selectedKey) ?? KeyName.c);

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Keyboard với highlight
                Container(
                  height: 120,
                  child: Keyboard(
                    props: KeyboardProps(
                      offset: octaveAdj,
                      highlightTable: highlightTable,
                      highlightColor: colorIndex,
                    ),
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
                // ChordDetail
                ChordDetail(
                  chord: chord,
                  inversion: inversion,
                  color: color,
                ),
                ChordSelector(selectedKey: keyName),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  child: Keyboard(props: KeyboardProps(offset: 0)),
                ),
                KeySelector(selectedKey: selectedKey, link: true),
                ChordSelector(selectedKey: keyName),
              ],
            ),
          ),
        ),
      );
    }
  }
} 