// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/sheet_models.dart';
// import '../data/placeholder_data.dart';
// import '../utils/chord_helper.dart';
//
// class LocalStorageService {
//   static const String _sheetsSavingKey = 'whiteboardSave';
//   static const String _activeSheetSavingKey = 'activeSheet';
//
//   // Serialize sheets by removing chord field from beats
//   static List<Map<String, dynamic>> _serializeSheets(List<Sheet> sheets) {
//     return sheets.map((sheet) => {
//       'title': sheet.title,
//       'key': sheet.key,
//       'mode': sheet.mode,
//       'lastEdit': sheet.lastEdit,
//       'bars': sheet.bars.map((bar) => {
//         'totalBeats': bar.totalBeats,
//         'beats': bar.beats.map((beat) => {
//           'duration': beat.duration,
//           'lyrics': beat.lyrics,
//           'chordDisplay': beat.chordDisplay,
//           // chord field is omitted during serialization
//         }).toList(),
//       }).toList(),
//     }).toList();
//   }
//
//   // Deserialize sheets and reconstruct chord field from chordDisplay
//   static List<Sheet> _deserializeSheets(List<dynamic> data) {
//     return data.map((sheetData) {
//       final bars = (sheetData['bars'] as List).map((barData) {
//         final beats = (barData['beats'] as List).map((beatData) {
//           final chordResult = ChordHelper.inferChord(beatData['chordDisplay'] ?? '');
//           return Beat(
//             chord: chordResult.chord,
//             duration: beatData['duration']?.toDouble() ?? 0.0,
//             lyrics: beatData['lyrics'] ?? '',
//             chordDisplay: beatData['chordDisplay'] ?? '',
//           );
//         }).toList();
//
//         return Bar(
//           totalBeats: barData['totalBeats'] ?? 4,
//           beats: beats,
//         );
//       }).toList();
//
//       return Sheet(
//         title: sheetData['title'] ?? '',
//         key: sheetData['key'] ?? 'C',
//         mode: sheetData['mode'] ?? 0,
//         bars: bars,
//         lastEdit: sheetData['lastEdit'] ?? DateTime.now().toString(),
//       );
//     }).toList();
//   }
//
//   // Save sheets to SharedPreferences
//   static Future<void> saveSheets(List<Sheet> sheets) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final serializedSheets = _serializeSheets(sheets);
//       final jsonString = jsonEncode(serializedSheets);
//       await prefs.setString(_sheetsSavingKey, jsonString);
//     } catch (e) {
//       print('Error saving sheets: $e');
//     }
//   }
//
//   // Load sheets from SharedPreferences
//   static Future<List<Sheet>> loadSheets() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savingStr = prefs.getString(_sheetsSavingKey);
//
//       if (savingStr == null || savingStr.isEmpty) {
//         return [PlaceholderData.jingoBellSheet];
//       }
//
//       final List<dynamic> data = jsonDecode(savingStr);
//       return _deserializeSheets(data);
//     } catch (e) {
//       print('Error loading sheets: $e');
//       return [PlaceholderData.jingoBellSheet];
//     }
//   }
//
//   // Load active sheet index
//   static Future<int> loadActiveSheet() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getInt(_activeSheetSavingKey) ?? 0;
//     } catch (e) {
//       print('Error loading active sheet: $e');
//       return 0;
//     }
//   }
//
//   // Save active sheet index
//   static Future<void> saveActiveSheet(int activeSheet) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt(_activeSheetSavingKey, activeSheet);
//     } catch (e) {
//       print('Error saving active sheet: $e');
//     }
//   }
//
//   // Clear all stored data (utility method)
//   static Future<void> clearAll() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_sheetsSavingKey);
//       await prefs.remove(_activeSheetSavingKey);
//     } catch (e) {
//       print('Error clearing storage: $e');
//     }
//   }
// }