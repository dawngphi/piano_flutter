// import 'package:flutter/material.dart';
// import '../logic/chord.dart';
// import '../logic/db.dart' as ModesData;
// import '../logic/helper.dart' as ChordHelper;
// import '../logic/key.dart' as KeyHelper;
// import '../logic/local_storage.dart';
// import '../logic/notifycation.dart' as NotificationService;
// import 'modal.dart';
//
// class WhiteBoardPage extends StatefulWidget {
//   const WhiteBoardPage({Key? key}) : super(key: key);
//
//   @override
//   State<WhiteBoardPage> createState() => _WhiteBoardPageState();
// }
//
// class _WhiteBoardPageState extends State<WhiteBoardPage> {
//   bool edit = true;
//   bool learning = false;
//   List<Sheet> sheets = [];
//   int activeSheet = 0;
//
//   // Modal states
//   bool showRootKeyModal = false;
//   bool showModeModal = false;
//   bool showAddBeatModal = false;
//   bool showNewSheetModal = false;
//   bool showOpenSheetModal = false;
//   bool showRenameSheetModal = false;
//
//   // Modal data
//   int addBeatBarIndex = 0;
//   int addBeatBeatIndex = 0;
//   int activeRome = 0;
//   String newSheetText = "";
//   String renameSheetText = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final loadedSheets = await LocalStorageService.loadSheets();
//     final loadedActiveSheet = await LocalStorageService.loadActiveSheet();
//
//     setState(() {
//       sheets = loadedSheets;
//       activeSheet = loadedActiveSheet >= loadedSheets.length ? 0 : loadedActiveSheet;
//     });
//   }
//
//   void _addBeatOnClick(int barIndex, int beatIndex) {
//     if (sheets[activeSheet].bars[barIndex].beats.length < 6) {
//       setState(() {
//         showAddBeatModal = true;
//         addBeatBarIndex = barIndex;
//         addBeatBeatIndex = beatIndex;
//       });
//     } else {
//       NotificationService.addNotification("Bạn đã đạt số lượng hợp âm tối đa trong một thanh.", 5000);
//     }
//   }
//
//   void _addBeat(Chord? chord, String chordDisplay, String lyrics) {
//     setState(() {
//       showAddBeatModal = false;
//       final beat = Beat(
//         chord: chord,
//         duration: 0,
//         lyrics: lyrics,
//         chordDisplay: chordDisplay,
//       );
//       sheets[activeSheet].bars[addBeatBarIndex].beats.insert(addBeatBeatIndex, beat);
//     });
//     _saveSheets();
//   }
//
//   void _addBar() {
//     if (sheets[activeSheet].bars.length > 60) {
//       NotificationService.addNotification("Bạn đã đạt số lượng thanh tối đa.", 5000);
//     } else {
//       setState(() {
//         sheets[activeSheet].bars.add(Bar(totalBeats: 4, beats: []));
//       });
//       _saveSheets();
//     }
//   }
//
//   void _shouldDeleteBeat(int barIndex, int beatIndex) {
//     final beat = sheets[activeSheet].bars[barIndex].beats[beatIndex];
//     if (beat.lyrics.isEmpty && beat.chordDisplay.isEmpty) {
//       setState(() {
//         sheets[activeSheet].bars[barIndex].beats.removeAt(beatIndex);
//         if (sheets[activeSheet].bars[barIndex].beats.isEmpty) {
//           sheets[activeSheet].bars.removeAt(barIndex);
//         }
//       });
//     }
//   }
//
//   void _newSheet() {
//     final emptySheet = Sheet(
//       title: newSheetText,
//       key: "C",
//       mode: 0,
//       bars: [Bar(totalBeats: 4, beats: [])],
//       lastEdit: DateTime.now().toString(),
//     );
//
//     setState(() {
//       sheets.add(emptySheet);
//       activeSheet = sheets.length - 1;
//       showNewSheetModal = false;
//       newSheetText = "";
//     });
//     _saveSheets();
//   }
//
//   void _renameSheet() {
//     setState(() {
//       sheets[activeSheet].title = renameSheetText;
//       showRenameSheetModal = false;
//       renameSheetText = "";
//     });
//     _saveSheets();
//   }
//
//   Future<void> _saveSheets() async {
//     sheets[activeSheet].lastEdit = DateTime.now().toString();
//     await LocalStorageService.saveSheets(sheets);
//     await LocalStorageService.saveActiveSheet(activeSheet);
//   }
//
//   void _deleteSheet(int index) {
//     if (sheets.length == 1) {
//       _showAlert("Bạn không thể xóa bảng trắng duy nhất bạn có.");
//       return;
//     }
//
//     _showConfirmDialog(
//       "Bạn có muốn xóa bảng trắng \"${sheets[index].title}\"? Bạn không thể khôi phục bảng trắng đã xóa.",
//           () {
//         setState(() {
//           sheets.removeAt(index);
//           if (activeSheet == index) {
//             activeSheet = 0;
//           }
//         });
//         _saveSheets();
//       },
//     );
//   }
//
//   void _showAlert(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showConfirmDialog(String message, VoidCallback onConfirm) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               onConfirm();
//             },
//             child: const Text("Xác nhận"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuContainer() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           _buildMenuButton("Mới", Icons.note_add, () {
//             setState(() {
//               showNewSheetModal = true;
//             });
//           }),
//           const Text(" / "),
//           _buildMenuButton("Đổi tên", Icons.edit, () {
//             setState(() {
//               showRenameSheetModal = true;
//               renameSheetText = sheets[activeSheet].title;
//             });
//           }),
//           const Text(" / "),
//           _buildMenuButton("Mở", Icons.folder_open, () {
//             setState(() {
//               showOpenSheetModal = true;
//             });
//           }),
//           const Text(" / "),
//           _buildMenuButton("Trợ giúp", Icons.help_outline, () {}),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuButton(String text, IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Text(text),
//           const SizedBox(width: 4),
//           Icon(icon, size: 18),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildControlBar() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () => setState(() => showRootKeyModal = true),
//                 child: Row(
//                   children: [
//                     const Text("Khóa: "),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _getKeyColor(sheets[activeSheet].key),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(sheets[activeSheet].key),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 20),
//               GestureDetector(
//                 onTap: () => setState(() => showModeModal = true),
//                 child: Row(
//                   children: [
//                     const Text("Chế độ: "),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _getModeColor(sheets[activeSheet].mode),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(ModesData.modesTable[sheets[activeSheet].mode].name),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               _buildToggle("Chế độ chỉnh sửa", edit, (value) {
//                 setState(() => edit = value);
//               }),
//               const SizedBox(width: 20),
//               _buildToggle("Chế độ học", learning, (value) {
//                 setState(() => learning = value);
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
//     return Row(
//       children: [
//         Text(label),
//         const SizedBox(width: 8),
//         Switch(
//           value: value,
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSheetContainer() {
//     return Expanded(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ...sheets[activeSheet].bars.asMap().entries.map((entry) {
//               final barIndex = entry.key;
//               final bar = entry.value;
//               return _buildBar(bar, barIndex);
//             }).toList(),
//             if (edit)
//               IconButton(
//                 onPressed: _addBar,
//                 icon: const Icon(Icons.add),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBar(Bar bar, int barIndex) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           if (edit)
//             IconButton(
//               onPressed: () => _addBeatOnClick(barIndex, 0),
//               icon: const Icon(Icons.add_circle_outline),
//             ),
//           ...bar.beats.asMap().entries.expand((entry) {
//             final beatIndex = entry.key;
//             final beat = entry.value;
//             return [
//               _buildBeat(beat, barIndex, beatIndex),
//               if (edit)
//                 IconButton(
//                   onPressed: () => _addBeatOnClick(barIndex, beatIndex + 1),
//                   icon: const Icon(Icons.add_circle_outline),
//                 ),
//             ];
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBeat(Beat beat, int barIndex, int beatIndex) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Column(
//         children: [
//           if (edit)
//             TextFormField(
//               initialValue: beat.chordDisplay,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Hợp âm",
//               ),
//               onFieldSubmitted: (value) {
//                 final inferred = ChordHelper.inferChord(value);
//                 setState(() {
//                   beat.chord = inferred.chord;
//                   beat.chordDisplay = inferred.chordDisplay;
//                 });
//                 _shouldDeleteBeat(barIndex, beatIndex);
//                 _saveSheets();
//               },
//             )
//           else
//             Text(beat.chordDisplay),
//           if (edit)
//             TextFormField(
//               initialValue: beat.lyrics,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Lời bài hát",
//               ),
//               onFieldSubmitted: (value) {
//                 setState(() {
//                   beat.lyrics = value;
//                 });
//                 _shouldDeleteBeat(barIndex, beatIndex);
//                 _saveSheets();
//               },
//             )
//           else
//             Text(beat.lyrics),
//         ],
//       ),
//     );
//   }
//
//   Color _getKeyColor(String key) {
//     final index = KeyHelper.keySimpleList.indexOf(key as KeyHelper.KeyName);
//     return Colors.primaries[index % Colors.primaries.length];
//   }
//
//   Color _getModeColor(int mode) {
//     return Colors.primaries[mode % Colors.primaries.length];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (sheets.isEmpty) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(sheets[activeSheet].title),
//       ),
//       body: Column(
//         children: [
//           _buildMenuContainer(),
//           _buildControlBar(),
//           _buildSheetContainer(),
//         ],
//       ),
//       // Modals
//       floatingActionButton: _buildModals(),
//     );
//   }
//
//   Widget _buildModals() {
//     return Stack(
//       children: [
//         // Root Key Modal
//         if (showRootKeyModal)
//           CustomModal(
//             onClose: () => setState(() => showRootKeyModal = false),
//             child: KeySelector(
//               selectedKey: sheets[activeSheet].key,
//               onKeySelected: (key) {
//                 setState(() {
//                   sheets[activeSheet].key = key;
//                   showRootKeyModal = false;
//                 });
//                 _saveSheets();
//               },
//             ),
//           ),
//
//         // Mode Modal
//         if (showModeModal)
//           CustomModal(
//             onClose: () => setState(() => showModeModal = false),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: ModesData.modesTable.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final mode = entry.value;
//                 return ListTile(
//                   title: Text(mode.name),
//                   selected: index == sheets[activeSheet].mode,
//                   onTap: () {
//                     setState(() {
//                       sheets[activeSheet].mode = index;
//                       showModeModal = false;
//                     });
//                     _saveSheets();
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//
//         // New Sheet Modal
//         if (showNewSheetModal)
//           CustomModal(
//             onClose: () => setState(() => showNewSheetModal = false),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text("Bảng trắng mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: "Tên",
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLength: 30,
//                   onChanged: (value) => newSheetText = value,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => setState(() => showNewSheetModal = false),
//                       child: const Text("Hủy"),
//                     ),
//                     ElevatedButton(
//                       onPressed: _newSheet,
//                       child: const Text("Tạo"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//         // Rename Sheet Modal
//         if (showRenameSheetModal)
//           CustomModal(
//             onClose: () => setState(() => showRenameSheetModal = false),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text("Đổi tên bảng trắng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: "Tên",
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLength: 30,
//                   controller: TextEditingController(text: renameSheetText),
//                   onChanged: (value) => renameSheetText = value,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => setState(() => showRenameSheetModal = false),
//                       child: const Text("Hủy"),
//                     ),
//                     ElevatedButton(
//                       onPressed: _renameSheet,
//                       child: const Text("Xác nhận"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//         // Open Sheet Modal
//         if (showOpenSheetModal)
//           CustomModal(
//             onClose: () => setState(() => showOpenSheetModal = false),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: sheets.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final sheet = entry.value;
//                 return ListTile(
//                   title: Text(sheet.title),
//                   subtitle: Text("Chỉnh sửa lần cuối: ${DateTime.parse(sheet.lastEdit).toLocal()}"),
//                   selected: index == activeSheet,
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteSheet(index),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       activeSheet = index;
//                       showOpenSheetModal = false;
//                     });
//                     _saveSheets();
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//       ],
//     );
//   }
// }