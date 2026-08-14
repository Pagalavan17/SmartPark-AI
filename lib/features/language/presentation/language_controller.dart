import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_state_providers.dart';

final appLanguageProvider = Provider<String>((ref) {
  return ref.watch(activeLanguageCodeProvider);
});