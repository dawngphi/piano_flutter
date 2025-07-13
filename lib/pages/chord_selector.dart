import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/app_bloc.dart';
import '../bloc/app_event.dart';
import '../logic/chord.dart';
import '../logic/db.dart';
import '../logic/helper.dart';
import '../logic/key.dart';
import 'chord_thumbnail.dart';

class ChordSelector extends StatefulWidget {
  final KeyName selectedKey;

  const ChordSelector({
    Key? key,
    required this.selectedKey,
  }) : super(key: key);

  @override
  State<ChordSelector> createState() => _ChordSelectorState();
}

class _ChordSelectorState extends State<ChordSelector> {
  String search = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChange);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChange() {
    setState(() {
      search = _searchController.text;
    });
  }

  void _handleChordTap(Chord chord) {
    final encodedKey = urlEncodeKey(widget.selectedKey.name);
    final encodedChord = urlEncodeChord(chord.alias.first);
    final route = '/chord/$encodedKey/$encodedChord';
    // Gửi event Bloc khi chọn hợp âm
    context.read<AppBloc>().add(SelectChordEvent(keyName: widget.selectedKey.name, chordName: chord.alias.first));
    Navigator.pushNamed(context, route);
  }

  Color _getColorFromIndex(int colorIndex) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.brown,
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepPurple,
      Colors.brown,
    ];
    if (colorIndex >= 0 && colorIndex < colors.length) {
      return colors[colorIndex];
    }
    return Colors.grey;
  }

  Future<void> _launchGitHubIssues() async {
    final url = Uri.parse('https://github.com/JNKKKK/pianochord.io/issues');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedKey = widget.selectedKey;
    final colorIndex = keySimpleList.indexOf(selectedKey) + 1;
    final themeColor = _getColorFromIndex(colorIndex);

    // Filter chords based on search
    final filteredChords = chords[selectedKey.name]
        ?.where(chordFilterByKeyword(search))
        .toList() ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Thêm dòng này
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by keywords',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: themeColor,
                ),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeColor.withOpacity(0.5)),
                ),
              ),
              style: TextStyle(color: themeColor),
            ),
          ),

          // Chords grid - Thay đổi từ Flexible thành Container với height cố định
          Container(
            height: 400, // Đặt height cố định thay vì dùng Flexible
            child: filteredChords.isNotEmpty
                ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredChords.length,
              itemBuilder: (context, index) {
                final chord = filteredChords[index];
                return _buildChordCard(chord, themeColor, colorIndex);
              },
            )
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildChordCard(Chord chord, Color themeColor, int colorIndex) {
    return GestureDetector(
      onTap: () => _handleChordTap(chord),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chord thumbnail
            Expanded( // Thay đổi từ Flexible thành Expanded
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: ChordThumbnail(
                    chord: chord,
                    highlightColor: colorIndex,
                  ),
                ),
              ),
            ),

            // Chord name
            Container( // Thay đổi từ Flexible thành Container
              height: 40, // Đặt height cố định
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  chord.shortName,
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No matching chords found!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To report missing chord definition,',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _launchGitHubIssues,
            child: Text(
              'open an issue here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}