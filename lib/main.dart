import 'package:flutter/material.dart';
import 'package:piano/pages/chord_detail.dart';
import 'package:piano/pages/index_page.dart';
import 'package:piano/pages/nav.dart';
import 'package:piano/pages/chord_page.dart'; // 👈 Thêm import này
import 'logic/audio.dart';

void main() {
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Demo',
      debugShowCheckedModeBanner: false,
      home: IndexPage(),

      // 👇 Thêm dòng này để xử lý route như /chord/C/
      onGenerateRoute: generateChordPageRoute,

      // 👇 Optional: xử lý nếu route không khớp
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const NotFoundPage(),
      ),
    );
  }
}
