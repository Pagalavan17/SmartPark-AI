import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension LocalizedContext on BuildContext {
  /// Convenient accessor for AppLocalizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
