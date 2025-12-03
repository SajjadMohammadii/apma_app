import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

bool get isDesktopOrWeb => true;

Future<void> downloadFile({
  required Uint8List bytes,
  required String fileName,
  required String mimeType,
  required BuildContext context,
}) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}
