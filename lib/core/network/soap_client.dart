// کلاینت SOAP برای ارتباط با وب‌سرویس‌های مبتنی بر XML
// مرتبط با: auth_remote_datasource.dart, network_info.dart

import 'package:http/http.dart' as http; // کتابخانه HTTP
import 'package:xml/xml.dart' as xml; // کتابخانه پردازش XML
import 'dart:developer' as developer; // ابزار لاگ‌گیری

// کلاس SoapClient - کلاینت برای ارسال درخواست‌های SOAP
class SoapClient {
  final String baseUrl; // آدرس پایه وب‌سرویس
  final http.Client httpClient; // کلاینت HTTP

  // سازنده - دریافت آدرس پایه و کلاینت HTTP اختیاری
  SoapClient({required this.baseUrl, http.Client? httpClient})
    : httpClient =
          httpClient ??
          http.Client(); // استفاده از کلاینت پیش‌فرض اگر داده نشده

  /// متد call - ارسال درخواست SOAP
  /// پارامتر method: نام متد وب‌سرویس
  /// پارامتر parameters: پارامترهای متد
  /// پارامتر namespace: فضای نام (اختیاری)
  /// پارامتر soapAction: اکشن SOAP (اختیاری)
  Future<xml.XmlDocument> call({
    required String method,
    required Map<String, String> parameters,
    String? namespace,
    String? soapAction,
  }) async {
    // ساخت پاکت SOAP
    final soapEnvelope = _buildSoapEnvelope(
      method: method,
      parameters: parameters,
      namespace: namespace ?? 'http://tempuri.org/',
    );

    // لاگ اطلاعات درخواست
    developer.log('📤 SOAP Method: $method');
    developer.log('📤 Namespace: ${namespace ?? "http://tempuri.org/"}');
    developer.log('📤 Parameters: $parameters');

    // تنظیم هدرهای HTTP
    final headers = {
      'Content-Type': 'text/xml; charset=utf-8', // نوع محتوا
      'User-Agent': 'Flutter SOAP Client', // شناسه کلاینت
      if (soapAction != null) 'SOAPAction': '"$soapAction"', // اکشن SOAP
    };

    try {
      // ارسال درخواست POST با timeout 30 ثانیه
      final response = await httpClient
          .post(Uri.parse(baseUrl), headers: headers, body: soapEnvelope)
          .timeout(
            const Duration(seconds: 30),
            onTimeout:
                () => throw SoapException('Connection timeout'), // خطای timeout
          );

      developer.log(
        '📥 Response Status: ${response.statusCode}',
      ); // لاگ کد وضعیت

      if (response.statusCode == 200) {
        // پاسخ موفق
        try {
          return xml.XmlDocument.parse(response.body); // پارس XML
        } catch (e) {
          throw SoapException('خطا در پارس XML: $e');
        }
      } else if (response.statusCode == 500) {
        // خطای سرور
        final errorMsg = _extractServerError(response.body);
        throw SoapException('Server Error 500: $errorMsg');
      } else {
        // سایر خطاها
        throw SoapException('HTTP ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      // خطای ارتباط
      throw SoapException('خطا در ارتباط با سرور: $e');
    } catch (e) {
      rethrow; // انتقال خطا
    }
  }

  /// متد _buildSoapEnvelope - ساخت پاکت SOAP (سازگار با .NET)
  /// پارامتر method: نام متد
  /// پارامتر parameters: پارامترها
  /// پارامتر namespace: فضای نام
  String _buildSoapEnvelope({
    required String method,
    required Map<String, String> parameters,
    required String namespace,
  }) {
    final buffer = StringBuffer(); // بافر برای ساخت رشته
    buffer.writeln('<?xml version="1.0" encoding="utf-8"?>'); // اعلان XML
    buffer.writeln(
      '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
      'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
      'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">', // تگ Envelope با namespaceها
    );
    buffer.writeln('<soap:Body>'); // شروع Body
    buffer.writeln('<$method xmlns="$namespace">'); // شروع متد با namespace
    // افزودن پارامترها
    parameters.forEach((key, value) {
      buffer.writeln('<$key>${_escapeXml(value)}</$key>');
    });
    buffer.writeln('</$method>'); // پایان متد
    buffer.writeln('</soap:Body>'); // پایان Body
    buffer.writeln('</soap:Envelope>'); // پایان Envelope
    return buffer.toString();
  }

  /// متد _escapeXml - فرار از کاراکترهای خاص XML
  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;') // علامت و
        .replaceAll('<', '&lt;') // کوچکتر از
        .replaceAll('>', '&gt;') // بزرگتر از
        .replaceAll('"', '&quot;') // نقل قول دوتایی
        .replaceAll("'", '&apos;'); // نقل قول تکی
  }

  /// متد _extractServerError - استخراج خطا از پاسخ سرور
  String _extractServerError(String body) {
    try {
      // جستجوی تگ faultstring
      final match = RegExp(
        r'<faultstring>(.*?)</faultstring>',
        dotAll: true,
      ).firstMatch(body);
      if (match != null) return match.group(1) ?? body;
      // برش رشته طولانی
      return body.length > 300 ? body.substring(0, 300) : body;
    } catch (e) {
      return body;
    }
  }

  /// متد extractValue - استخراج مقدار از سند XML
  /// پارامتر doc: سند XML
  /// پارامتر tagName: نام تگ مورد نظر
  String? extractValue(xml.XmlDocument doc, String tagName) {
    try {
      final elements = doc.findAllElements(
        tagName,
      ); // یافتن تمام المان‌ها با این نام
      if (elements.isNotEmpty) {
        final value = elements.first.innerText; // گرفتن متن داخلی اولین المان
        developer.log('✅ مقدار یافت شد برای $tagName (${value.length} chars)');
        return value;
      }
      developer.log('⚠️ مقدار یافت نشد برای $tagName');
      return null;
    } catch (e) {
      developer.log('❌ Error extractValue: $e');
      return null;
    }
  }

  // متد dispose - بستن کلاینت HTTP
  void dispose() => httpClient.close();
}

// کلاس SoapException - استثنای مخصوص خطاهای SOAP
class SoapException implements Exception {
  final String message; // پیام خطا
  SoapException(this.message); // سازنده
  @override
  String toString() => message; // تبدیل به رشته
}
