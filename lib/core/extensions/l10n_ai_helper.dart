import 'package:flutter/material.dart';
import 'l10n_extension.dart';

extension LocalizedAiContent on BuildContext {
  /// Helper to localize AI reasoning summaries in presentation layer
  String localizeAiReasoning(String text) {
    if (text.isEmpty) return text;
    final l10n = this.l10n;

    if (text.contains('Highly suitable parking location with good availability')) {
      return l10n.highlySuitableLocation;
    }
    if (text.contains('Lowest predicted route traffic')) {
      return l10n.lowestRouteTraffic;
    }
    if (text.contains('Competitive parking price')) {
      return l10n.competitivePrice;
    }
    final metersMatch = RegExp(r'Walking distance only (\d+) meters').firstMatch(text);
    if (metersMatch != null) {
      final meters = int.tryParse(metersMatch.group(1) ?? '0') ?? 0;
      return l10n.walkingDistanceMeters(meters);
    }

    return text;
  }
}
