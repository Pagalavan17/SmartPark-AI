import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Helper utility for capturing, saving, and sharing QR Parking Passes
class QrPassHelper {
  /// Captures a RepaintBoundary widget key to Uint8List PNG bytes
  static Future<Uint8List?> capturePng(GlobalKey repaintKey) async {
    try {
      final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing QR Pass image: $e');
      return null;
    }
  }

  /// Downloads & saves captured image to Android Gallery using Gal
  static Future<void> downloadPass({
    required BuildContext context,
    required GlobalKey repaintKey,
    required String passId,
  }) async {
    try {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating QR Pass...'), duration: Duration(seconds: 1)),
      );

      final pngBytes = await capturePng(repaintKey);
      if (pngBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to save QR Pass: Image capture failed')),
          );
        }
        return;
      }

      final fileName = 'parking_pass_${passId.replaceAll('#', '').replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(pngBytes, name: fileName);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR Pass saved to Gallery.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save QR Pass: $e')),
        );
      }
    }
  }

  /// Shares captured image via native Android share sheet using share_plus
  static Future<void> sharePass({
    required BuildContext context,
    required GlobalKey repaintKey,
    required String passId,
    required String parkingName,
  }) async {
    try {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preparing QR Pass...'), duration: Duration(seconds: 1)),
      );

      final pngBytes = await capturePng(repaintKey);
      if (pngBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to share QR Pass: Image capture failed')),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final cleanPassId = passId.replaceAll('#', '').replaceAll(' ', '_');
      final tempFile = File('${tempDir.path}/parking_pass_$cleanPassId.png');
      await tempFile.writeAsBytes(pngBytes);

      final xFile = XFile(tempFile.path, mimeType: 'image/png');
      await Share.shareXFiles(
        [xFile],
        text: 'My Parking Pass - $parkingName',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to share QR Pass: $e')),
        );
      }
    }
  }
}
