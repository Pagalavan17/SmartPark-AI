import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global App State Providers
final isAppInitializedProvider = StateProvider<bool>((ref) => false);
final activeLanguageCodeProvider = StateProvider<String>((ref) => 'en');
final isDarkModeProvider = StateProvider<bool>((ref) => false);
