import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scaner_test_task/core/utils/routers/routes.dart';
import 'package:scaner_test_task/features/documents/data/models/document.dart';

import 'pdf_preview_widget.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key, required this.document});
  final Document document;

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('EEE, MMM d, y').format(document.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.documentInfo.name,
          arguments: document,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color(0xFFF5F5F5),
              ),
              child: PdfPreviewWidget(pdfFile: File(document.path)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateString,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF364EFF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
