import 'package:flutter/material.dart';
import '../logic/db.dart';
import '../logic/helper.dart';
import '../logic/note.dart';

class Playbox extends StatelessWidget {
  final int offset;
  final List<bool> highlightTable;
  final VoidCallback raiseOctave;
  final VoidCallback lowerOctave;
  final bool risingDisabled;
  final bool lowerDisabled;
  final int color;

  const Playbox({
    Key? key,
    required this.offset,
    required this.highlightTable,
    required this.raiseOctave,
    required this.lowerOctave,
    required this.risingDisabled,
    required this.lowerDisabled,
    required this.color,
  }) : super(key: key);

  Future<void> playChord(List<Note> notes) async {
    // Play all notes simultaneously with slight delay for chord effect
    final futures = <Future>[];
    for (int i = 0; i < notes.length; i++) {
      futures.add(
        Future.delayed(
          Duration(milliseconds: i * 50), // Small delay between notes
              () => notes[i].play(),
        ),
      );
    }
    await Future.wait(futures);
  }

  Future<void> playEachNote(List<Note> notes) async {
    for (final note in notes) {
      await note.play();
      await delay(300);
    }
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
    ];

    if (colorIndex >= 0 && colorIndex < colors.length) {
      return colors[colorIndex];
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final noteOffset = 12 * (1 + offset);
    final notesList = notes.sublist(noteOffset, noteOffset + 36);
    final highlightedNotes = notesList
        .asMap()
        .entries
        .where((entry) =>
    entry.key < highlightTable.length && highlightTable[entry.key])
        .map((entry) => entry.value)
        .toList();

    final themeColor = _getColorFromIndex(color);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play buttons row
          Row(
            children: [
              Expanded(
                child: _buildPlayButton(
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: 'Play',
                  onPressed: highlightedNotes.isNotEmpty
                      ? () => playChord(highlightedNotes)
                      : null,
                  color: themeColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPlayButton(
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: 'Play each note',
                  onPressed: highlightedNotes.isNotEmpty
                      ? () => playEachNote(highlightedNotes)
                      : null,
                  color: themeColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Octave control buttons row
          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  icon: const Icon(Icons.arrow_downward, size: 16),
                  label: 'Octave Down',
                  onPressed: lowerDisabled ? null : lowerOctave,
                  color: themeColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildControlButton(
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: 'Octave Up',
                  onPressed: risingDisabled ? null : raiseOctave,
                  color: themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton({
    required Widget icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: onPressed != null ? 2 : 0,
      ),
    );
  }

  Widget _buildControlButton({
    required Widget icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: Colors.grey.shade400,
        side: BorderSide(
          color: onPressed != null ? color : Colors.grey.shade300,
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}