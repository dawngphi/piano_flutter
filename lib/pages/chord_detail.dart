import 'package:flutter/material.dart';
import '../logic/chord.dart';
import '../logic/db.dart';
import '../logic/key.dart';
import 'chord_thumbnail.dart';

class ChordDetail extends StatefulWidget {
  final Chord chord;
  final int inversion;
  final int color;

  const ChordDetail({
    Key? key,
    required this.chord,
    required this.inversion,
    required this.color,
  }) : super(key: key);

  @override
  State<ChordDetail> createState() => _ChordDetailState();
}

class _ChordDetailState extends State<ChordDetail> {
  late bool inversionOpen;

  @override
  void initState() {
    super.initState();
    inversionOpen = widget.inversion == 0 ? false : true;
  }

  void _handleInversionClick(int i) {
    // Flutter navigation - you'll need to implement this based on your routing setup
    // This is equivalent to the route() function in the original code
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    List<String> pathSegments = currentRoute.split('/');

    if (pathSegments.length == 4) {
      pathSegments.add(i.toString());
    } else if (pathSegments.length == 5) {
      pathSegments[4] = i.toString();
    }

    if (i == 0) {
      pathSegments = pathSegments.sublist(0, 4);
    }

    String newRoute = pathSegments.join('/');
    Navigator.pushReplacementNamed(context, newRoute);
  }

  Color _getColorFromIndex(int colorIndex) {
    // Define your color palette here
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
    final chord = widget.chord;

    return Container(
      decoration: BoxDecoration(
        color: _getColorFromIndex(widget.color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main information container
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.inversion == 0
                      ? chord.name
                      : chord.inversions[widget.inversion - 1].alias[0],
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getColorFromIndex(widget.color),
                  ),
                ),

                const SizedBox(height: 16),

                // Information section
                if (widget.inversion == 0) ...[
                  _buildInfoRow('Tonic', chord.tonic),
                  _buildInfoRow(
                      'Interval',
                      chord.intervals.map((i) => intervalTable[i]?.abbrev ?? '').join(', ')
                  ),
                  if (chord.quality.isNotEmpty)
                    _buildInfoRow('Quality', chord.quality),
                  if (chord.fullName.isNotEmpty)
                    _buildInfoRow('Aliases', chord.alias.join(', ')),
                  if (chord.fullName.isEmpty && chord.alias.length > 1)
                    _buildInfoRow('Aliases', chord.alias.skip(1).join(', ')),
                ] else ...[
                  _buildInfoRow('Inversion', inversionNames[widget.inversion]),
                  _buildInfoRow(
                      'Root Position Chord',
                      chord.fullName.isNotEmpty ? chord.fullName : chord.alias[0]
                  ),
                  if (chord.alias.length > 1)
                    _buildInfoRow(
                        'Alias',
                        chord.inversions[widget.inversion - 1].alias.skip(1).join(', ')
                    ),
                ],
              ],
            ),
          ),

          // Inversions section
          if (chord.inversions.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Inversions header
                  InkWell(
                    onTap: () {
                      setState(() {
                        inversionOpen = !inversionOpen;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: inversionOpen
                            ? Colors.grey.shade100
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Inversions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            inversionOpen
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Inversions content
                  if (inversionOpen)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [chord, ...chord.inversions].asMap().entries.map((entry) {
                          final i = entry.key;
                          final c = entry.value;
                          final colorIndex = keySimpleList
                              .map((str) => keys[str]!)
                              .toList()
                              .indexOf(c.key) + 1;
                          final isActive = widget.inversion == i;

                          return GestureDetector(
                            onTap: () => _handleInversionClick(i),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? _getColorFromIndex(colorIndex).withOpacity(0.2)
                                    : Colors.white,
                                border: Border.all(
                                  color: isActive
                                      ? _getColorFromIndex(colorIndex)
                                      : Colors.grey.shade300,
                                  width: isActive ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Chord title
                                  Text(
                                    inversionNames[i],
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isActive
                                          ? _getColorFromIndex(colorIndex)
                                          : Colors.grey.shade600,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Chord thumbnail
                                  ChordThumbnail(
                                    chord: c,
                                    highlightColor: colorIndex,
                                  ),

                                  const SizedBox(height: 8),

                                  // Chord name
                                  Text(
                                    c.alias[0],
                                    style: Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}