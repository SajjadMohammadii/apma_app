import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

bool get isDesktopOrWeb {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

Future<void> downloadFile({
  required Uint8List bytes,
  required String fileName,
  required String mimeType,
  required BuildContext context,
}) async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فایل ذخیره شد: ${file.path}')));
    }
  }
}
