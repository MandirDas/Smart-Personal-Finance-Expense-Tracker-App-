import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all Theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to toggle theme between light and dark
class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

/// Event to set specific theme mode
class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const SetTheme(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// Event to load saved theme preference
class LoadTheme extends ThemeEvent {
  const LoadTheme();
}
