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
    return _buildKeyView(selectedKey);
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