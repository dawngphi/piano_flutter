import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First line
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchUrl('https://pianochord.io/'),
                child: const Text(
                  'PianoChord.io',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const Text(
                ' made with ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.black87,
                ),
              ),
              const Text(
                '❤',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.red,
                ),
              ),
              const Text(
                ' by ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () => _launchUrl('https://nk.dev'),
                child: const Text(
                  'Enkai Ji',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const Text(
                '.',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Second line
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Open sourced at ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _launchUrl('https://github.com/JNKKKK/pianochord.io'),
                child: const Text(
                  'Github',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}