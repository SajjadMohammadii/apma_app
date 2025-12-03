import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class PrintService {
  /// Global Key جهت کپچر ویجت - فقط برای موبایل
  static final GlobalKey _captureKey = GlobalKey();
  static GlobalKey get captureKey => _captureKey;

  /// بررسی پلتفرم دسکتاپ
  static bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  // -----------------------------
  // 🖨️ پرینت از Widget (فقط موبایل)
  // -----------------------------
  static Future<void> printWidget({required String fileName}) async {
    try {
      developer.log('🖨️ شروع پرینت ویجت');

      // در دسکتاپ از capture استفاده نکن
      if (_isDesktop) {
        developer.log(
          '⚠️ printWidget در دسکتاپ پشتیبانی نمی‌شود. از printPdf استفاده کنید.',
        );
        return;
      }

      final imageBytes = await _captureRenderedWidget();

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(child: pw.Image(pw.MemoryImage(imageBytes))),
        ),
      );

      await Printing.layoutPdf(name: fileName, onLayout: (_) => pdf.save());

      developer.log('✅ پرینت ویجت موفق');
    } catch (e) {
      developer.log('❌ خطا در پرینت ویجت: $e');
    }
  }

  // -----------------------------
  //  ساخت PDF سفارشی و پرینت/ذخیره
  // -----------------------------
  static Future<void> printPdf(
    BuildContext context,
    Future<Uint8List> Function(PdfPageFormat format) pdfBuilder, {
    String? fileName,
  }) async {
    try {
      developer.log("📄 شروع ساخت PDF");

      await Printing.layoutPdf(
        name: fileName ?? "custom_pdf_${DateTime.now().millisecondsSinceEpoch}",
        onLayout: pdfBuilder,
      );

      developer.log("✅ PDF موفق");
    } catch (e) {
      developer.log("❌ خطا در ساخت PDF: $e");
    }
  }

  // -----------------------------
  // 📄 خروجی PDF (share/save)
  // -----------------------------
  static Future<void> exportPdf({
    required BuildContext context,
    required Future<Uint8List> Function(PdfPageFormat format) pdfBuilder,
    required String fileName,
  }) async {
    try {
      developer.log("📄 شروع خروجی PDF");

      final pdfBytes = await pdfBuilder(PdfPageFormat.a4.landscape);

      // --- Desktop: ذخیره مستقیم ---
      if (_isDesktop) {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/$fileName.pdf";

        final file = File(path);
        await file.writeAsBytes(pdfBytes);

        developer.log("✔ فایل PDF ذخیره شد در: $path");

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فایل ذخیره شد: $path')));
        }
        return;
      }

      // --- Mobile/Web: share ---
      await Printing.sharePdf(bytes: pdfBytes, filename: '$fileName.pdf');

      developer.log("✅ خروجی PDF موفق");
    } catch (e) {
      developer.log("❌ خطا در خروجی PDF: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در ایجاد PDF: $e')));
      }
    }
  }

  // خروجی Excel

  static Future<Uint8List> exportExcel({
    required List<String> columns,
    required List<List<dynamic>> rows,
    String? sheetName,
  }) async {
    try {
      developer.log("📊 ساخت Excel...");
      developer.log("📊 تعداد ستون‌ها: ${columns.length}");
      developer.log("📊 تعداد ردیف‌ها: ${rows.length}");

      final excel = Excel.createExcel();
      final String sheet = sheetName ?? "Sheet1";

      // استفاده از شیت موجود
      final sheetObj = excel[sheet];

      // اگر شیت پیش‌فرض متفاوت است، حذفش کن
      if (sheet != "Sheet1" && excel.tables.containsKey("Sheet1")) {
        excel.delete('Sheet1');
      }

      // ستون‌ها
      sheetObj.appendRow(
        columns.map((col) => TextCellValue(col.toString())).toList(),
      );

      // ردیف‌ها
      for (var row in rows) {
        sheetObj.appendRow(
          row.map((cell) => TextCellValue(cell.toString())).toList(),
        );
      }

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('خطا در encode کردن Excel');
      }

      developer.log("✅ خروجی Excel موفق - سایز: ${bytes.length} bytes");

      return Uint8List.fromList(bytes);
    } catch (e) {
      developer.log("❌ خطا در ساخت Excel: $e");
      rethrow;
    }
  }

  // -----------------------------
  // 📊 خروجی Excel (share/save)
  // -----------------------------
  static Future<void> downloadExcel({
    required BuildContext context,
    required List<String> columns,
    required List<List<dynamic>> rows,
    required String fileName,
    String? sheetName,
  }) async {
    try {
      developer.log("📊 شروع دانلود Excel");
      developer.log("📊 تعداد ردیف‌ها: ${rows.length}");

      if (rows.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('داده‌ای برای خروجی وجود ندارد')),
          );
        }
        return;
      }

      final excelBytes = await exportExcel(
        columns: columns,
        rows: rows,
        sheetName: sheetName,
      );

      // --- Desktop: ذخیره مستقیم ---
      if (_isDesktop) {
        final directory = await getApplicationDocumentsDirectory();
        final path = "${directory.path}/$fileName.xlsx";

        final file = File(path);
        await file.writeAsBytes(excelBytes);

        developer.log("✔ فایل Excel ذخیره شد در: $path");

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فایل ذخیره شد: $path')));
        }
        return;
      }

      // --- Mobile/Web: share ---
      await Share.shareXFiles([
        XFile.fromData(
          excelBytes,
          name: '$fileName.xlsx',
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ], subject: fileName);

      developer.log("✅ دانلود Excel موفق");
    } catch (e) {
      developer.log("❌ خطا در دانلود Excel: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا در ایجاد Excel: $e')));
      }
    }
  }

  static Future<Uint8List> _captureRenderedWidget() async {
    try {
      final boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      await Future.delayed(const Duration(milliseconds: 50));

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      developer.log("❌ خطا در کپچر ویجت: $e");
      rethrow;
    }
  }
}
