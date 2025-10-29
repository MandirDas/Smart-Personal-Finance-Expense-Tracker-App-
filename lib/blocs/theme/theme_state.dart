import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme state
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  /// Initial system default theme
  factory ThemeState.initial() {
    return const ThemeState(themeMode: ThemeMode.system);
  }

  /// Copy with new theme mode
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object?> get props => [themeMode];
}
