import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class SelectChordEvent extends AppEvent {
  final String keyName;
  final String chordName;
  const SelectChordEvent({required this.keyName, required this.chordName});

  @override
  List<Object?> get props => [keyName, chordName];
}

class SelectKeyEvent extends AppEvent {
  final String keyName;
  const SelectKeyEvent({required this.keyName});

  @override
  List<Object?> get props => [keyName];
}
