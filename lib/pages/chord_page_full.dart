import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import '../bloc/app_event.dart';
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
  const ChordPageFull({Key? key}) : super(key: key);

  @override
  State<ChordPageFull> createState() => _ChordPageFullState();
}

class _ChordPageFullState extends State<ChordPageFull> {
  int octaveAdj = 0;

  @override
  void initState() {
    super.initState();
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

  void _navigateToNotFound() {
    Navigator.of(context).pushReplacementNamed('/404');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final selectedKey = state.selectedKey;
        final selectedChord = state.selectedChord;
        final inversion = 0; // Có thể mở rộng Bloc để quản lý inversion nếu cần

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
      },
    );
  }
} 