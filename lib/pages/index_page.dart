import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'key_selector.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse('https://github.com/JNKKKK/pianochord.io');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const footerHeight = 70.0;

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(maxWidth: 1008), // 63rem = ~1008px
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SizedBox(
            height: screenHeight - footerHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main title with gradient
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFB827FC), // #b827fc
                      Color(0xFF2C90FC), // #2c90fc
                      Color(0xFFB8FD33), // #b8fd33
                      Color(0xFFFEC837), // #fec837
                      Color(0xFFfd1892), // #fd1892
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    'PianoChord.io',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Subtitle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: const Text(
                    'A Reference to a Comprehensive Collection of Piano Chords',
                    style: TextStyle(
                      fontSize: 20.8, // 1.3rem
                      color: Color(0xFF434343),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // GitHub link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Open Sourced at ',
                      style: TextStyle(
                        fontSize: 17.6, // 1.1rem
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Icon(
                      Icons.code,
                      size: 14,
                      color: Colors.black,
                    ),
                    GestureDetector(
                      onTap: _launchGitHub,
                      child: const Text(
                        'Github',
                        style: TextStyle(
                          fontSize: 17.6, // 1.1rem
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  margin: const EdgeInsets.only(top: 30), // 4rem
                  padding: const EdgeInsets.all(12), // 0.75rem
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 3,
                        color: Color(0xFFB827FC),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Select a root key to continue',
                    style: TextStyle(
                      fontSize: 19.2, // 1.2rem
                      color: Color(0xFF434343),
                    ),
                  ),
                ),

                // Key selector
                const SizedBox(height: 16),
                const Expanded(
                  child: KeySelector(link: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getResponsiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSize = screenWidth * 0.12;
    return responsiveSize < 72 ? responsiveSize : 72;
  }
}