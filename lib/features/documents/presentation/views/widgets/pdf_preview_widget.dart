import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewWidget extends StatelessWidget {
  const PdfPreviewWidget({super.key, required this.pdfFile});
  final File pdfFile;

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: pdfFile.path,
      onError: (error) {
        debugPrint("PDFView Error: $error");
      },
    );
  }
}
