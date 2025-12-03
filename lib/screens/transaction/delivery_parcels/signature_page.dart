import 'dart:io';
import 'package:apma_app/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignaturePage extends StatefulWidget {
  final String customerName;
  final String location;

  const SignaturePage({
    super.key,
    required this.customerName,
    required this.location,
  });

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final List<Offset?> _signaturePoints = [];

  bool get _isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();
    if (_isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              onPressed: _saveSignature,
              icon: const Icon(Icons.check, size: 18, color: Colors.white),
              label: const Text(
                'تایید و ذخیره',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // باکس امضا
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 60,
                    right: 60,
                    bottom: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.draw,
                              color: AppColors.primaryPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'لطفاً در کادر زیر امضا کنید',
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed:
                                  () =>
                                      setState(() => _signaturePoints.clear()),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text(
                                'پاک کردن',
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // کادر امضا
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(
                                    color: Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onPanStart:
                                          (d) => setState(
                                            () => _signaturePoints.add(
                                              d.localPosition,
                                            ),
                                          ),
                                      onPanUpdate:
                                          (d) => setState(
                                            () => _signaturePoints.add(
                                              d.localPosition,
                                            ),
                                          ),
                                      onPanEnd:
                                          (d) => setState(
                                            () => _signaturePoints.add(null),
                                          ),
                                      child: CustomPaint(
                                        size: Size(
                                          constraints.maxWidth,
                                          constraints.maxHeight,
                                        ),
                                        painter: SignaturePainter(
                                          _signaturePoints,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSignature() {
    if (_signaturePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'لطفاً امضا کنید',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.pop(context, true);
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
