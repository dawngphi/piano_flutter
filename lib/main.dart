import 'package:flutter/material.dart';
import 'package:piano/pages/index_page.dart';
import 'package:piano/pages/chord_page.dart';

void main() {
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Demo',
      debugShowCheckedModeBanner: false,
      home: const IndexPage(),

      // 👇 THÊM CÁI NÀY
      onGenerateRoute: (RouteSettings settings) {
        final uri = Uri.parse(settings.name!);

        if (uri.pathSegments.length == 3 &&
            uri.pathSegments[0] == 'chord') {
          final selectedKey = uri.pathSegments[1];
          final selectedChord = uri.pathSegments[2];

          return MaterialPageRoute(
            builder: (context) => ChordPage(
              selectedKey: selectedKey,
              selectedChord: selectedChord,
            ),
          );
        }

        // Add more route parsing here if needed

        // fallback: 404 page
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
        );
      },
    );
  }
}

