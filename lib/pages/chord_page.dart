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
import 'chord_detail.dart';
import 'chord_selector.dart';
import 'key_board.dart';
import 'key_selector.dart';

const int maxOctaveAdj = 1;
const int minOctaveAdj = -1;

class ChordPage extends StatefulWidget {
  const ChordPage({Key? key}) : super(key: key);

  @override
  State<ChordPage> createState() => _ChordPageState();
}

class _ChordPageState extends State<ChordPage> {
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
        return _buildKeyView(selectedKey);
      },
    );
  }

  Widget _buildKeyView(String selectedKey) {
    final keyName = parseKeyName(selectedKey);
    if (keyName == null) {
      _navigateToNotFound();
      return const SizedBox.shrink();
    }
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