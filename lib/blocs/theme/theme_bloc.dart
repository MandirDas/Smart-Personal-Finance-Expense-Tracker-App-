import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../services/database_helper.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// BLoC for managing theme (light/dark mode)
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final DatabaseHelper _databaseHelper;

  ThemeBloc({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        super(ThemeState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
    on<LoadTheme>(_onLoadTheme);
  }

  /// Toggle between light and dark theme
  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newThemeMode));
    await _saveThemePreference(newThemeMode);
  }

  /// Set specific theme mode
  Future<void> _onSetTheme(
    SetTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _saveThemePreference(event.themeMode);
  }

  /// Load saved theme preference
  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final themeMode = await _loadThemePreference();
    emit(state.copyWith(themeMode: themeMode));
  }

  /// Save theme preference to database
  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    try {
      final db = await _databaseHelper.database;

      // Save theme preference
      await db.insert(
        'settings',
        {'key': 'theme_mode', 'value': themeMode.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Silently fail - theme will reset to default
    }
  }

  /// Load theme preference from database
  Future<ThemeMode> _loadThemePreference() async {
    try {
      final db = await _databaseHelper.database;

      final result = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: ['theme_mode'],
      );

      if (result.isNotEmpty) {
        final value = result.first['value'] as String;
        if (value == 'ThemeMode.dark') return ThemeMode.dark;
        if (value == 'ThemeMode.light') return ThemeMode.light;
        if (value == 'ThemeMode.system') return ThemeMode.system;
      }
    } catch (e) {
      // Silently fail - return default theme
    }
    return ThemeMode.system;
  }
}
