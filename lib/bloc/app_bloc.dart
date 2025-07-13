import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/db.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<SelectChordEvent>((event, emit) {
      emit(state.copyWith(selectedKey: event.keyName, selectedChord: event.chordName));
    });
    on<SelectKeyEvent>((event, emit) {
      final chordList = chords[event.keyName];
      String? newChord;
      if (chordList != null && chordList.isNotEmpty) {
        // Nếu hợp âm cũ vẫn tồn tại ở âm mới, giữ nguyên
        if (state.selectedChord != null &&
            chordList.any((chord) => chord.alias.contains(state.selectedChord))) {
          newChord = state.selectedChord;
        }
        // Nếu có hợp âm 'Maj', chọn 'Maj'
        else if (chordList.any((chord) => chord.alias.contains('Maj'))) {
          newChord = 'Maj';
        }
        // Nếu không, chọn hợp âm đầu tiên
        else {
          newChord = chordList.first.alias.first;
        }
      } else {
        newChord = null;
      }
      emit(state.copyWith(
        selectedKey: event.keyName,
        selectedChord: newChord,
      ));
    });
    // Thêm các event handler khác nếu cần
  }
} 