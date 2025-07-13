import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final String? selectedKey;
  final String? selectedChord;

  const AppState({this.selectedKey, this.selectedChord});

  AppState copyWith({String? selectedKey, String? selectedChord}) {
    return AppState(
      selectedKey: selectedKey ?? this.selectedKey,
      selectedChord: selectedChord ?? this.selectedChord,
    );
  }

  @override
  List<Object?> get props => [selectedKey, selectedChord];
} 